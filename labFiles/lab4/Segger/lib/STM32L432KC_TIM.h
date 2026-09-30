// STM32L432KC_TIM.h
// Timer registers and functions.

#ifndef STM32L4_TIM_H
#define STM32L4_TIM_H

#include <stdint.h>

#ifndef __IO
#define __IO volatile
#endif

// Base addresses

#define TIM1_BASE  (0x40012C00UL)
#define TIM2_BASE  (0x40000000UL)
#define TIM15_BASE (0x40014000UL)
#define TIM16_BASE (0x40014400UL)

// Register map 

typedef struct {
  __IO uint32_t CR1;   // 0x00 Control 1
  __IO uint32_t CR2;   // 0x04 Control 2
  __IO uint32_t SMCR;  // 0x08 Slave mode control
  __IO uint32_t DIER;  // 0x0C DMA/interrupt enable
  __IO uint32_t SR;    // 0x10 Status
  __IO uint32_t EGR;   // 0x14 Event generation
  __IO uint32_t CCMR1; // 0x18 Capture/compare mode 1
  __IO uint32_t CCMR2; // 0x1C Capture/compare mode 2
  __IO uint32_t CCER;  // 0x20 Capture/compare enable
  __IO uint32_t CNT;   // 0x24 Counter
  __IO uint32_t PSC;   // 0x28 Prescaler
  __IO uint32_t ARR;   // 0x2C Auto-reload
  __IO uint32_t RCR;   // 0x30 Repetition counter (TIM1/15/16 only)
  __IO uint32_t CCR1;  // 0x34 Capture/compare 1
  __IO uint32_t CCR2;  // 0x38 Capture/compare 2
  __IO uint32_t CCR3;  // 0x3C Capture/compare 3
  __IO uint32_t CCR4;  // 0x40 Capture/compare 4
  __IO uint32_t BDTR;  // 0x44 Break and dead-time (TIM1/15/16 only)
  __IO uint32_t DCR;   // 0x48 DMA control
  __IO uint32_t DMAR;  // 0x4C DMA address for full transfer
  __IO uint32_t OR1;   // 0x50 Option 1
  __IO uint32_t CCMR3; // 0x54 Capture/compare mode 3 (TIM1 only)
  __IO uint32_t CCR5;  // 0x58 Capture/compare 5     (TIM1 only)
  __IO uint32_t CCR6;  // 0x5C Capture/compare 6     (TIM1 only)
  __IO uint32_t OR2;   // 0x60 Option 2
  __IO uint32_t OR3;   // 0x64 Option 3
} TIM_TypeDef;

#define TIM1  ((TIM_TypeDef *) TIM1_BASE)
#define TIM2  ((TIM_TypeDef *) TIM2_BASE)
#define TIM15 ((TIM_TypeDef *) TIM15_BASE)
#define TIM16 ((TIM_TypeDef *) TIM16_BASE)

// Bit definitions

// TIMx_CR1
#define TIM_CR1_CEN   (1UL << 0)   // Counter enable
#define TIM_CR1_UDIS  (1UL << 1)   // Update disable
#define TIM_CR1_URS   (1UL << 2)   // Update request source
#define TIM_CR1_OPM   (1UL << 3)   // One-pulse mode
#define TIM_CR1_ARPE  (1UL << 7)   // Auto-reload preload enable

// TIMx_SR
#define TIM_SR_UIF    (1UL << 0)   // Update interrupt flag

// TIMx_EGR
#define TIM_EGR_UG    (1UL << 0)   // Update generation

// TIMx_CCMR1 
#define TIM_CCMR1_CC1S_Msk  (0x3UL << 0)                    // 00 = CH1 is an output
#define TIM_CCMR1_OC1PE     (1UL << 3)                      // CCR1 preload enable
#define TIM_CCMR1_OC1M_Msk  ((0x7UL << 4) | (1UL << 16))    // OC1M[2:0] and OC1M[3]
#define TIM_CCMR1_OC1M_PWM1 (0x6UL << 4)                    // 0110 = PWM mode 1

// TIMx_CCER
#define TIM_CCER_CC1E (1UL << 0)   // CH1 output enable
#define TIM_CCER_CC1P (1UL << 1)   // CH1 polarity 

// TIMx_BDTR
#define TIM_BDTR_MOE  (1UL << 15)  // Main output enable 


// Timing constants

#ifndef TIM_CLK_FREQ
#define TIM_CLK_FREQ 16000000UL    
#endif

#define PWM_TICK_FREQ   1000000UL 
#define DELAY_TICK_FREQ 1000000UL  

// Supported pitch range for the 16-bit PWM timer 
#define PWM_MIN_FREQ 16UL    
#define PWM_MAX_FREQ 20000UL   

// Longest single delay

#define DELAY_MAX_MS (0xFFFFFFFFUL / (DELAY_TICK_FREQ / 1000UL))   


// Function prototypes

// PWM generator
void initPWM(TIM_TypeDef * TIMx);
int  setPWMFreq(TIM_TypeDef * TIMx, uint32_t freq);

void initTIM(TIM_TypeDef * TIMx);
void delay_millis(TIM_TypeDef * TIMx, uint32_t ms);

#endif
