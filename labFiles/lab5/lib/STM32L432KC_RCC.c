// STM32L432KC_RCC.c
// Source code for RCC functions

#include "STM32L432KC_RCC.h"
#include "STM32L432KC_PWR.h"

void enableHSI16(void) {
  RCC->CR |= RCC_CR_HSION;                         // turn on the 16 MHz oscillator
  while ((RCC->CR & RCC_CR_HSIRDY) == 0);          // wait for HSIRDY
}

void selectSysclk(uint32_t sw) {
  RCC->CFGR = (RCC->CFGR & ~RCC_CFGR_SW_Msk) | (sw << RCC_CFGR_SW_Pos); // One read-modify-write
  while (((RCC->CFGR & RCC_CFGR_SWS_Msk) >> RCC_CFGR_SWS_Pos) != sw);
}

void setAHBPrescaler(uint32_t hpre) {
  // HCLK = SYSCLK / (AHB prescaler)
  RCC->CFGR = (RCC->CFGR & ~RCC_CFGR_HPRE_Msk) | (hpre << RCC_CFGR_HPRE_Pos);
}

void setAPBPrescalers(uint32_t ppre1, uint32_t ppre2) {
  // PCLK1 = HCLK / (APB1 prescaler), PCLK2 = HCLK / (APB2 prescaler).
  RCC->CFGR = (RCC->CFGR & ~(RCC_CFGR_PPRE1_Msk | RCC_CFGR_PPRE2_Msk))
            | (ppre1 << RCC_CFGR_PPRE1_Pos) | (ppre2 << RCC_CFGR_PPRE2_Pos);
}

void configurePLL(uint32_t src, uint32_t m, uint32_t n, uint32_t r) {
  // PLLCLK = (src / M) * N / R

  RCC->CR &= ~RCC_CR_PLLON;
  while (RCC->CR & RCC_CR_PLLRDY);

  RCC->PLLCFGR &= ~RCC_PLLCFGR_PLLSRC_Msk;         // input clk src
  RCC->PLLCFGR |= (src << RCC_PLLCFGR_PLLSRC_Pos);

  RCC->PLLCFGR &= ~RCC_PLLCFGR_PLLM_Msk;           // M field
  RCC->PLLCFGR |= ((m - 1) << RCC_PLLCFGR_PLLM_Pos);

  RCC->PLLCFGR &= ~RCC_PLLCFGR_PLLN_Msk;           // N field
  RCC->PLLCFGR |= (n << RCC_PLLCFGR_PLLN_Pos);

  RCC->PLLCFGR &= ~RCC_PLLCFGR_PLLR_Msk;           // R field
  RCC->PLLCFGR |= ((r / 2 - 1) << RCC_PLLCFGR_PLLR_Pos);

  RCC->PLLCFGR |= RCC_PLLCFGR_PLLREN;              // enable R output

  RCC->CR |= RCC_CR_PLLON;                         // turn on the PLL and wait for lock
  while ((RCC->CR & RCC_CR_PLLRDY) == 0);
}

void configureClock(void) {
  enableHSI16();
  setAHBPrescaler(HPRE_DIV1);
  setAPBPrescalers(PPRE_DIV1, PPRE_DIV1);
  selectSysclk(SW_HSI16);
}

void startLSE(void) {
  // The LSE control bits live in the backup domain, which is write-protected
  enableBackupDomainWrite();

  // Takes about 2 s to start (may already be running after a reset)
  RCC->BDCR |= RCC_BDCR_LSEON;
}

int lseReady(void) {
  return (RCC->BDCR & RCC_BDCR_LSERDY) != 0;
}
