// STM32L432KC_PWR.c
// Source code for PWR functions

#include "STM32L432KC_PWR.h"
#include "STM32L432KC_RCC.h"

void enableBackupDomainWrite(void) {
  RCC->APB1ENR1 |= RCC_APB1ENR1_PWREN;
  (void) RCC->APB1ENR1;                            // read back so the clock is on before PWR is written

  PWR->CR1 |= PWR_CR1_DBP;
  while ((PWR->CR1 & PWR_CR1_DBP) == 0);           // wait until the backup domain is writable
}
