// STM32L432KC_RCC.c
// Source code for RCC functions

#include "STM32L432KC_RCC.h"

void enableHSI16(void) {
  RCC->CR |= RCC_CR_HSION;                         // turn on the 16 MHz oscillator
  while ((RCC->CR & RCC_CR_HSIRDY) == 0);          // wait for HSIRDY
}

void selectSysclk(uint32_t sw) {
  RCC->CFGR = (RCC->CFGR & ~RCC_CFGR_SW_Msk) | (sw << 0); // One read-modify-write
  while (((RCC->CFGR >> 2) & 0b11) != sw);
}

void setAHBPrescaler(uint32_t hpre) {
  // HCLK = SYSCLK / (AHB prescaler)
  RCC->CFGR = (RCC->CFGR & ~RCC_CFGR_HPRE_Msk) | (hpre << 4);
}

void setAPBPrescalers(uint32_t ppre1, uint32_t ppre2) {
  // PCLK1 = HCLK / (APB1 prescaler), PCLK2 = HCLK / (APB2 prescaler).
  RCC->CFGR = (RCC->CFGR & ~(RCC_CFGR_PPRE1_Msk | RCC_CFGR_PPRE2_Msk))
            | (ppre1 << 8) | (ppre2 << 11);
}

void configurePLL(uint32_t src, uint32_t m, uint32_t n, uint32_t r) {
  // PLLCLK = (src / M) * N / R

  RCC->CR &= ~RCC_CR_PLLON;
  while (RCC->CR & RCC_CR_PLLRDY);

  RCC->PLLCFGR &= ~(0b11 << 0);                    // input clk src
  RCC->PLLCFGR |= (src << 0);

  RCC->PLLCFGR &= ~(0b111 << 4);                   // M field 
  RCC->PLLCFGR |= ((m - 1) << 4);

  RCC->PLLCFGR &= ~(0b1111111 << 8);               // N field 
  RCC->PLLCFGR |= (n << 8);

  RCC->PLLCFGR &= ~(0b11 << 25);                   // R field
  RCC->PLLCFGR |= ((r / 2 - 1) << 25);

  RCC->PLLCFGR |= (1 << 24);                       // enable R output 

  RCC->CR |= RCC_CR_PLLON;                         // turn on the PLL and wait for lock
  while ((RCC->CR & RCC_CR_PLLRDY) == 0);
}

void configureClock(void) {
  enableHSI16();
  setAHBPrescaler(HPRE_DIV1);                     
  setAPBPrescalers(PPRE_DIV1, PPRE_DIV1);          
  selectSysclk(SW_HSI16);
}
