// STM32L432KC_TIM.c
// Source code for timer functions

#include "STM32L432KC.h"

// PWM square-wave generator (TIM1 channel 1)

void initPWM(TIM_TypeDef * TIMx) {
  TIMx->CR1  = 0;
  TIMx->SMCR = 0;

  // Prescaler: f_CK_CNT = f_TIM / (PSC + 1) = 16 MHz / 16 = 1 MHz
  TIMx->PSC = (TIM_CLK_FREQ / PWM_TICK_FREQ) - 1;
  TIMx->RCR = 0;
  TIMx->ARR = TIM_ARR_MAX_16BIT;
  TIMx->CCR1 = 0;

  // Channel 1: output, PWM mode 1 (high while CNT < CCR1)
  TIMx->CCMR1 &= ~(TIM_CCMR1_CC1S_Msk | TIM_CCMR1_OC1M_Msk);
  TIMx->CCMR1 |=  TIM_CCMR1_OC1M_PWM1 | TIM_CCMR1_OC1PE;

  TIMx->CCER &= ~TIM_CCER_CC1P;
  TIMx->CCER |=  TIM_CCER_CC1E;
  TIMx->BDTR |=  TIM_BDTR_MOE;

  TIMx->CR1 |= TIM_CR1_ARPE;
  TIMx->EGR  = TIM_EGR_UG;
  TIMx->SR   = (uint32_t) ~TIM_SR_UIF;
  TIMx->CR1 |= TIM_CR1_CEN;
}

int setPWMFreq(TIM_TypeDef * TIMx, uint32_t freq) {
  int status = 0;

  if (freq != 0 && (freq < PWM_MIN_FREQ || freq > PWM_MAX_FREQ)) {
    status = -1;                                   // out of range
    freq = 0;
  }

  if (freq == 0) {
    // Rest
    TIMx->CCR1 = 0;
  } else {
    // Period in ticks
    uint32_t period = (PWM_TICK_FREQ + freq / 2) / freq;
    TIMx->ARR  = period - 1;                       // counter runs to N ticks
    TIMx->CCR1 = period / 2;                       // 50% duty cycle
  }

  TIMx->EGR = TIM_EGR_UG;
  return status;
}

// Delay timer (TIM2, 32-bit)

void initTIM(TIM_TypeDef * TIMx) {
  // One-pulse mode
  TIMx->CR1  = TIM_CR1_OPM | TIM_CR1_URS;
  TIMx->SMCR = 0;

  // Prescaler: f_CK_CNT = 16 MHz / 16 = 1 MHz
  TIMx->PSC = (TIM_CLK_FREQ / DELAY_TICK_FREQ) - 1;
  TIMx->EGR = TIM_EGR_UG;
  TIMx->SR  = (uint32_t) ~TIM_SR_UIF;
}

void delay_millis(TIM_TypeDef * TIMx, uint32_t ms) {
  if (ms == 0) return;
  if (ms > DELAY_MAX_MS) ms = DELAY_MAX_MS;

  // Counter runs 0 to ARR
  TIMx->ARR = ms * (DELAY_TICK_FREQ / MS_PER_S) - 1;
  TIMx->EGR = TIM_EGR_UG;
  TIMx->SR  = (uint32_t) ~TIM_SR_UIF;
  TIMx->CR1 |= TIM_CR1_CEN;

  while ((TIMx->SR & TIM_SR_UIF) == 0);
  TIMx->SR = (uint32_t) ~TIM_SR_UIF;
}

// Peripheral clock enable

void enableTIMClock(TIM_TypeDef * TIMx) {
  if      (TIMx == TIM1)  RCC->APB2ENR  |= RCC_APB2ENR_TIM1EN;
  else if (TIMx == TIM2)  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;
  else if (TIMx == TIM6)  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM6EN;
  else if (TIMx == TIM7)  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM7EN;
  else if (TIMx == TIM15) RCC->APB2ENR  |= RCC_APB2ENR_TIM15EN;
  else if (TIMx == TIM16) RCC->APB2ENR  |= RCC_APB2ENR_TIM16EN;

  // Read back so the clock is running before the first timer register access
  (void) RCC->APB1ENR1;
  (void) RCC->APB2ENR;
}

// Periodic update interrupt (TIM6/TIM7, 16-bit)

int initPeriodicTIM(TIM_TypeDef * TIMx, uint32_t period_ms) {
  if (period_ms == 0 || period_ms > PERIODIC_MAX_MS) return -1;   // out of range, timer left off

  // URS: only a counter overflow sets UIF, so the UG below does not fire an interrupt
  TIMx->CR1 = TIM_CR1_URS;

  // Prescaler: f_CK_CNT = 16 MHz / 16000 = 1 kHz
  TIMx->PSC = (TIM_CLK_FREQ / PERIODIC_TICK_FREQ) - 1;

  // Counter runs 0 to ARR, so UIF is set every ARR + 1 = period_ms ticks
  TIMx->ARR = period_ms * (PERIODIC_TICK_FREQ / MS_PER_S) - 1;
  TIMx->EGR = TIM_EGR_UG;                          // load PSC, clear CNT
  TIMx->SR  = (uint32_t) ~TIM_SR_UIF;

  TIMx->DIER |= TIM_DIER_UIE;
  TIMx->CR1  |= TIM_CR1_CEN;
  return 0;
}

int timUpdatePending(TIM_TypeDef * TIMx) {
  return (TIMx->SR & TIM_SR_UIF) != 0;
}

void timClearUpdate(TIM_TypeDef * TIMx) {
  TIMx->SR = (uint32_t) ~TIM_SR_UIF;               // rc_w0: writing 1 to the other flags has no effect
}
