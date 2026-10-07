// STM32L432KC_RCC.h
// Reset and clock control (RCC) functions.

#ifndef STM32L4_RCC_H
#define STM32L4_RCC_H

#include <stdint.h>
#include <stm32l432xx.h>   // CMSIS: RCC struct and bit definitions

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

// LPTIM1 kernel clock select
#define LPTIM1SEL_LSE 0b11

// Function prototypes

// Clock-configuration
void enableHSI16(void);
void selectSysclk(uint32_t sw);
void setAHBPrescaler(uint32_t hpre);
void setAPBPrescalers(uint32_t ppre1, uint32_t ppre2);
void configurePLL(uint32_t src, uint32_t m, uint32_t n, uint32_t r);

void configureClock(void);

// 32.768 kHz LSE crystal
void startLSE(void);
int  lseReady(void);

#endif
