// STM32L432KC_GPIO.h
// General-purpose I/O registers and functions.

#ifndef STM32L4_GPIO_H
#define STM32L4_GPIO_H

#include <stdint.h>

#ifndef __IO
#define __IO volatile
#endif

// Base addresses

#define GPIOA_BASE (0x48000000UL)
#define GPIOB_BASE (0x48000400UL)
#define GPIOC_BASE (0x48000800UL)

// Register map (offsets from the RM0394 GPIO register map)

typedef struct {
  __IO uint32_t MODER;   // 0x00 Mode
  __IO uint32_t OTYPER;  // 0x04 Output type
  __IO uint32_t OSPEEDR; // 0x08 Output speed
  __IO uint32_t PUPDR;   // 0x0C Pull-up/pull-down
  __IO uint32_t IDR;     // 0x10 Input data
  __IO uint32_t ODR;     // 0x14 Output data
  __IO uint32_t BSRR;    // 0x18 Bit set/reset
  __IO uint32_t LCKR;    // 0x1C Configuration lock
  __IO uint32_t AFRL;    // 0x20 Alternate function low 
  __IO uint32_t AFRH;    // 0x24 Alternate function high 
  __IO uint32_t BRR;     // 0x28 Bit reset
} GPIO_TypeDef;

#define GPIOA ((GPIO_TypeDef *) GPIOA_BASE)
#define GPIOB ((GPIO_TypeDef *) GPIOB_BASE)
#define GPIOC ((GPIO_TypeDef *) GPIOC_BASE)

// Definitions

// Port IDs
#define GPIO_PORT_A 0
#define GPIO_PORT_B 1
#define GPIO_PORT_C 2

// MODER values
#define GPIO_INPUT  0b00
#define GPIO_OUTPUT 0b01
#define GPIO_ALT    0b10
#define GPIO_ANALOG 0b11

// Pin IDs
#define PA0  0
#define PA1  1
#define PA2  2
#define PA3  3
#define PA4  4
#define PA5  5
#define PA6  6
#define PA7  7
#define PA8  8
#define PA9  9
#define PA10 10
#define PA11 11
#define PA12 12
#define PA13 13
#define PA14 14
#define PA15 15
#define PB0  16
#define PB1  17
#define PB3  19
#define PB4  20
#define PB5  21
#define PB6  22
#define PB7  23
#define PC14 46
#define PC15 47

// Function prototypes

void gpioEnable(int port_id);
GPIO_TypeDef * gpioPinToBase(int gpio_pin);
void pinMode(int gpio_pin, int mode);
void pinAltFunction(int gpio_pin, int af);  
void digitalWrite(int gpio_pin, int val);

#endif
