// STM32L432KC_GPIO.h
// General-purpose I/O functions.

#ifndef STM32L4_GPIO_H
#define STM32L4_GPIO_H

#include <stdint.h>
#include <stm32l432xx.h>   // CMSIS: GPIO struct

// Definitions

// Pin IDs
#define GPIO_PORT_SHIFT     4
#define GPIO_PIN_OFFSET_MSK 0xF

// Register fields
#define GPIO_2BIT_WIDTH       2
#define GPIO_2BIT_MSK         0b11UL
#define GPIO_AF_WIDTH         4
#define GPIO_AF_MSK           0xFUL
#define GPIO_PINS_PER_AFR     8
#define GPIO_BSRR_RESET_SHIFT 16

// Port IDs
#define GPIO_PORT_A 0
#define GPIO_PORT_B 1
#define GPIO_PORT_C 2

// MODER values
#define GPIO_INPUT  0b00
#define GPIO_OUTPUT 0b01
#define GPIO_ALT    0b10
#define GPIO_ANALOG 0b11

// PUPDR values
#define GPIO_PULL_NONE 0b00
#define GPIO_PULL_UP   0b01
#define GPIO_PULL_DOWN 0b10

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
int  gpioPinToPort(int gpio_pin);
int  gpioPinOffset(int gpio_pin);
GPIO_TypeDef * gpioPinToBase(int gpio_pin);
void pinMode(int gpio_pin, int mode);
void pinResistor(int gpio_pin, int pull);
void pinAltFunction(int gpio_pin, int af);
int  digitalRead(int gpio_pin);
void digitalWrite(int gpio_pin, int val);

#endif
