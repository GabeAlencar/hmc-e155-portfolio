// STM32L432KC_EXTI.h
// External interrupt (EXTI) functions.

#ifndef STM32L4_EXTI_H
#define STM32L4_EXTI_H

#include <stdint.h>
#include <stm32l432xx.h>  

// Definitions

// SYSCFG_EXTICRx
#define SYSCFG_EXTICR_LINES_PER_REG 4
#define SYSCFG_EXTICR_FIELD_WIDTH   4
#define SYSCFG_EXTICR_FIELD_MSK     0xFUL

// Edge selections
#define EXTI_RISING_EDGE  0b01
#define EXTI_FALLING_EDGE 0b10
#define EXTI_BOTH_EDGES   (EXTI_RISING_EDGE | EXTI_FALLING_EDGE)

// Function prototypes

int  extiEnableInterrupt(int gpio_pin, int edges);  
int  extiPending(int gpio_pin);
void extiClearPending(int gpio_pin);

#endif
