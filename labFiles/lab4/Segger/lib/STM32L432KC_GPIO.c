// STM32L432KC_GPIO.c
// Source code for GPIO functions

#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_RCC.h"

void gpioEnable(int port_id) {
  switch (port_id) {
    case GPIO_PORT_A: RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN; break;
    case GPIO_PORT_B: RCC->AHB2ENR |= RCC_AHB2ENR_GPIOBEN; break;
    case GPIO_PORT_C: RCC->AHB2ENR |= RCC_AHB2ENR_GPIOCEN; break;
    default: break;
  }
}

GPIO_TypeDef * gpioPinToBase(int gpio_pin) {
  switch (gpio_pin >> 4) {
    case GPIO_PORT_A: return GPIOA;
    case GPIO_PORT_B: return GPIOB;
    case GPIO_PORT_C: return GPIOC;
    default:          return GPIOA;  
  }
}

void pinMode(int gpio_pin, int mode) {
  GPIO_TypeDef * port = gpioPinToBase(gpio_pin);
  int offset = gpio_pin & 0xF;

  port->MODER &= ~(0b11UL << (2 * offset));                    // clear field
  port->MODER |=  ((uint32_t)(mode & 0b11) << (2 * offset));   // set new mode
}

void pinAltFunction(int gpio_pin, int af) {
  GPIO_TypeDef * port = gpioPinToBase(gpio_pin);
  int offset = gpio_pin & 0xF;

  if (offset < 8) {
    port->AFRL &= ~(0xFUL << (4 * offset));
    port->AFRL |=  ((uint32_t)(af & 0xF) << (4 * offset));
  } else {
    port->AFRH &= ~(0xFUL << (4 * (offset - 8)));
    port->AFRH |=  ((uint32_t)(af & 0xF) << (4 * (offset - 8)));
  }
}

void digitalWrite(int gpio_pin, int val) {
  GPIO_TypeDef * port = gpioPinToBase(gpio_pin);
  int offset = gpio_pin & 0xF;

  // BSRR
  if (val) port->BSRR = (1UL << offset);
  else     port->BSRR = (1UL << (offset + 16));
}
