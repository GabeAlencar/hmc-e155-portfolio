// STM32L432KC_LPTIM.h
// Low-power timer (LPTIM) functions.

#ifndef STM32L4_LPTIM_H
#define STM32L4_LPTIM_H

#include <stdint.h>
#include <stm32l432xx.h>   // CMSIS: LPTIM struct and bit definitions

// Limits
#define LPTIM_MIN_TICKS     2UL        // ARR must be greater than CMP (0)
#define LPTIM_MAX_TICKS     0x10000UL  // 16-bit ARR
#define LPTIM_SYNC_TIMEOUT  100000UL   // polling loops (a register write takes ~100 us)

// Function prototypes

// Periodic interrupt every period_ticks LSE cycles (LSE must already be running)
int  initPeriodicLPTIM(LPTIM_TypeDef * LPTIMx, uint32_t period_ticks);   // 0 on success, -1 on error
int  lptimUpdatePending(LPTIM_TypeDef * LPTIMx);
void lptimClearUpdate(LPTIM_TypeDef * LPTIMx);

#endif
