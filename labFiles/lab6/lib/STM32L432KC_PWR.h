// STM32L432KC_PWR.h
// Power control (PWR) functions.

#ifndef STM32L4_PWR_H
#define STM32L4_PWR_H

#include <stm32l432xx.h>   // CMSIS: PWR struct and bit definitions

// Function prototypes

void enableBackupDomainWrite(void);   // needed before writing RCC_BDCR (LSE)

#endif
