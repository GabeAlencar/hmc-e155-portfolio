// STM32L432KC_TIM.h
// Timer functions.

#ifndef STM32L4_TIM_H
#define STM32L4_TIM_H

#include <stdint.h>
#include <stm32l432xx.h>   // CMSIS: TIM struct and bit definitions

// Field values

// TIMx_CCMR1 OC1M
#define TIM_CCMR1_OC1M_PWM1 (0x6UL << TIM_CCMR1_OC1M_Pos)   // 0110 = PWM mode 1

// Timing constants

#ifndef TIM_CLK_FREQ
#define TIM_CLK_FREQ 16000000UL
#endif

#ifndef MS_PER_S
#define MS_PER_S           1000UL
#endif

#define PWM_TICK_FREQ      1000000UL
#define DELAY_TICK_FREQ    1000000UL
#define PERIODIC_TICK_FREQ 1000UL      // 1 ms ticks for periodic interrupts

// Supported pitch range for the 16-bit PWM timer
#define PWM_MIN_FREQ 16UL
#define PWM_MAX_FREQ 20000UL
#define TIM_ARR_MAX_16BIT 0xFFFFUL   // largest ARR on a 16-bit timer

// Longest single delay

#define DELAY_MAX_MS (0xFFFFFFFFUL / (DELAY_TICK_FREQ / MS_PER_S))

// Longest periodic interrupt (TIM6/TIM7 ARR is 16 bits, so at most 2^16 ticks)
#define PERIODIC_MAX_MS ((TIM_ARR_MAX_16BIT + 1) / (PERIODIC_TICK_FREQ / MS_PER_S))


// Function prototypes

// PWM generator
void initPWM(TIM_TypeDef * TIMx);
int  setPWMFreq(TIM_TypeDef * TIMx, uint32_t freq);

// Delay timer
void initTIM(TIM_TypeDef * TIMx);
void delay_millis(TIM_TypeDef * TIMx, uint32_t ms);

// Peripheral clock enable for any timer above
void enableTIMClock(TIM_TypeDef * TIMx);

// Periodic update interrupt
int  initPeriodicTIM(TIM_TypeDef * TIMx, uint32_t period_ms);   // 0 on success, -1 if period_ms is 0 or too long
int  timUpdatePending(TIM_TypeDef * TIMx);
void timClearUpdate(TIM_TypeDef * TIMx);

#endif
