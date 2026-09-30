// STM32L432KC_RCC.h
// Reset and clock control (RCC) registers and functions.

#ifndef STM32L4_RCC_H
#define STM32L4_RCC_H

#include <stdint.h>

#ifndef __IO
#define __IO volatile
#endif

// Base address

#define RCC_BASE (0x40021000UL) 


// Field values

// PLL input clock source 
#define PLLSRC_MSI    0b01
#define PLLSRC_HSI16  0b10

// System clock switch 
#define SW_MSI    0b00
#define SW_HSI16  0b01
#define SW_PLL    0b11

// AHB prescaler 
#define HPRE_DIV1  0b0000
#define HPRE_DIV4  0b1001

// APB1/APB2 prescalers
#define PPRE_DIV1  0b000

// Register map 

typedef struct {
  __IO uint32_t CR;          // 0x00 Clock control
  __IO uint32_t ICSCR;       // 0x04 Internal clock sources calibration
  __IO uint32_t CFGR;        // 0x08 Clock configuration
  __IO uint32_t PLLCFGR;     // 0x0C PLL configuration
  __IO uint32_t PLLSAI1CFGR; // 0x10 PLLSAI1 configuration
  uint32_t      RESERVED0;   // 0x14
  __IO uint32_t CIER;        // 0x18 Clock interrupt enable
  __IO uint32_t CIFR;        // 0x1C Clock interrupt flag
  __IO uint32_t CICR;        // 0x20 Clock interrupt clear
  uint32_t      RESERVED1;   // 0x24
  __IO uint32_t AHB1RSTR;    // 0x28 AHB1 peripheral reset
  __IO uint32_t AHB2RSTR;    // 0x2C AHB2 peripheral reset
  __IO uint32_t AHB3RSTR;    // 0x30 AHB3 peripheral reset
  uint32_t      RESERVED2;   // 0x34
  __IO uint32_t APB1RSTR1;   // 0x38 APB1 peripheral reset 1
  __IO uint32_t APB1RSTR2;   // 0x3C APB1 peripheral reset 2
  __IO uint32_t APB2RSTR;    // 0x40 APB2 peripheral reset
  uint32_t      RESERVED3;   // 0x44
  __IO uint32_t AHB1ENR;     // 0x48 AHB1 peripheral clock enable
  __IO uint32_t AHB2ENR;     // 0x4C AHB2 peripheral clock enable
  __IO uint32_t AHB3ENR;     // 0x50 AHB3 peripheral clock enable
  uint32_t      RESERVED4;   // 0x54
  __IO uint32_t APB1ENR1;    // 0x58 APB1 peripheral clock enable 1
  __IO uint32_t APB1ENR2;    // 0x5C APB1 peripheral clock enable 2
  __IO uint32_t APB2ENR;     // 0x60 APB2 peripheral clock enable
} RCC_TypeDef;

#define RCC ((RCC_TypeDef *) RCC_BASE)

// Bit definitions

// RCC_CR
#define RCC_CR_HSION        (1UL << 8)   // HSI16 oscillator enable
#define RCC_CR_HSIRDY       (1UL << 10)  // HSI16 oscillator ready
#define RCC_CR_PLLON        (1UL << 24)  // Main PLL enable
#define RCC_CR_PLLRDY       (1UL << 25)  // Main PLL locked

// RCC_CFGR field masks
#define RCC_CFGR_SW_Msk     (0x3UL << 0)   // System clock switch
#define RCC_CFGR_SWS_Msk    (0x3UL << 2)   // System clock switch status
#define RCC_CFGR_HPRE_Msk   (0xFUL << 4)   // AHB prescaler
#define RCC_CFGR_PPRE1_Msk  (0x7UL << 8)   // APB1 prescaler
#define RCC_CFGR_PPRE2_Msk  (0x7UL << 11)  // APB2 prescaler

// RCC_AHB2ENR
#define RCC_AHB2ENR_GPIOAEN (1UL << 0)
#define RCC_AHB2ENR_GPIOBEN (1UL << 1)
#define RCC_AHB2ENR_GPIOCEN (1UL << 2)

// RCC_APB1ENR1
#define RCC_APB1ENR1_TIM2EN (1UL << 0)
#define RCC_APB1ENR1_TIM6EN (1UL << 4)

// RCC_APB2ENR
#define RCC_APB2ENR_TIM1EN  (1UL << 11)
#define RCC_APB2ENR_TIM15EN (1UL << 16)
#define RCC_APB2ENR_TIM16EN (1UL << 17)


// Function prototypes

// Clock-configuration
void enableHSI16(void);
void selectSysclk(uint32_t sw);
void setAHBPrescaler(uint32_t hpre);
void setAPBPrescalers(uint32_t ppre1, uint32_t ppre2);
void configurePLL(uint32_t src, uint32_t m, uint32_t n, uint32_t r);

void configureClock(void);

#endif
