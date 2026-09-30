// STM32L432KC.h
// Top-level header for register-level drivers.

#ifndef STM32L4_H
#define STM32L4_H

#include <stdint.h>

#ifndef __IO
#define __IO volatile
#endif

// Clock frequencies (Hz)
#define HSI16_FREQ   16000000UL 
#define SYSCLK_FREQ  HSI16_FREQ   
#define TIM_CLK_FREQ SYSCLK_FREQ 

#include "STM32L432KC_RCC.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_TIM.h"

#endif
