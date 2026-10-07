// STM32L432KC_LPTIM.c
// Source code for LPTIM functions

#include "STM32L432KC_LPTIM.h"
#include "STM32L432KC_RCC.h"

static void enableLPTIM1ClockLSE(void) {
  RCC->APB1ENR1 |= RCC_APB1ENR1_LPTIM1EN;          // register interface clock
  (void) RCC->APB1ENR1;                            // read back so the clock is on before LPTIM1 is written
  RCC->CCIPR &= ~RCC_CCIPR_LPTIM1SEL_Msk;          // count the LSE crystal
  RCC->CCIPR |= (LPTIM1SEL_LSE << RCC_CCIPR_LPTIM1SEL_Pos);
}

static int waitForFlag(LPTIM_TypeDef * LPTIMx, uint32_t flag) {
  for (uint32_t i = 0; i < LPTIM_SYNC_TIMEOUT; i++) {
    if (LPTIMx->ISR & flag) return 0;
  }
  return -1;
}

int initPeriodicLPTIM(LPTIM_TypeDef * LPTIMx, uint32_t period_ticks) {
  if (LPTIMx != LPTIM1) return -1;                 // only LPTIM1's clock select is handled
  if (period_ticks < LPTIM_MIN_TICKS || period_ticks > LPTIM_MAX_TICKS) return -1;

  enableLPTIM1ClockLSE();

  // CFGR and IER can only be written while the timer is disabled
  LPTIMx->CR   = 0;
  LPTIMx->CFGR = 0;                                // internal (LSE) clock, no prescaler, software start
  LPTIMx->IER  = LPTIM_IER_ARRMIE;

  // ARR can only be written while enabled. The write is copied into the LSE
  // clock domain, so wait for ARROK before starting the counter.
  LPTIMx->CR  = LPTIM_CR_ENABLE;
  LPTIMx->ICR = LPTIM_ICR_ARROKCF;
  LPTIMx->ARR = period_ticks - 1;               
  if (waitForFlag(LPTIMx, LPTIM_ISR_ARROK) != 0) {
    LPTIMx->CR = 0;                                
    return -1;
  }

  LPTIMx->CR |= LPTIM_CR_CNTSTRT;             
  return 0;
}

int lptimUpdatePending(LPTIM_TypeDef * LPTIMx) {
  return (LPTIMx->ISR & LPTIM_ISR_ARRM) != 0;
}

void lptimClearUpdate(LPTIM_TypeDef * LPTIMx) {
  LPTIMx->ICR = LPTIM_ICR_ARRMCF;
  (void) LPTIMx->ISR;                              // read back so the clear lands before the handler returns
}
