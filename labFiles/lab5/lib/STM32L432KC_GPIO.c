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
  (void) RCC->AHB2ENR;                           
}

int gpioPinToPort(int gpio_pin) {
  return gpio_pin >> GPIO_PORT_SHIFT;
}

int gpioPinOffset(int gpio_pin) {
  return gpio_pin & GPIO_PIN_OFFSET_MSK;
}

GPIO_TypeDef * gpioPinToBase(int gpio_pin) {
  switch (gpioPinToPort(gpio_pin)) {
    case GPIO_PORT_A: return GPIOA;
    case GPIO_PORT_B: return GPIOB;
    case GPIO_PORT_C: return GPIOC;
    default:          return GPIOA;
  }
}

void pinMode(int gpio_pin, int mode) {
  GPIO_TypeDef * port = gpioPinToBase(gpio_pin);
  int offset = gpioPinOffset(gpio_pin);

  port->MODER &= ~(GPIO_2BIT_MSK << (GPIO_2BIT_WIDTH * offset));                // clear field
  port->MODER |=  ((uint32_t)(mode & GPIO_2BIT_MSK) << (GPIO_2BIT_WIDTH * offset)); // set new mode
}

void pinResistor(int gpio_pin, int pull) {
  GPIO_TypeDef * port = gpioPinToBase(gpio_pin);
  int offset = gpioPinOffset(gpio_pin);

  port->PUPDR &= ~(GPIO_2BIT_MSK << (GPIO_2BIT_WIDTH * offset));                // clear field
  port->PUPDR |=  ((uint32_t)(pull & GPIO_2BIT_MSK) << (GPIO_2BIT_WIDTH * offset)); // set new pull
}

void pinAltFunction(int gpio_pin, int af) {
  GPIO_TypeDef * port = gpioPinToBase(gpio_pin);
  int offset = gpioPinOffset(gpio_pin);

  if (offset < GPIO_PINS_PER_AFR) {
    port->AFR[0] &= ~(GPIO_AF_MSK << (GPIO_AF_WIDTH * offset));
    port->AFR[0] |=  ((uint32_t)(af & GPIO_AF_MSK) << (GPIO_AF_WIDTH * offset));
  } else {
    port->AFR[1] &= ~(GPIO_AF_MSK << (GPIO_AF_WIDTH * (offset - GPIO_PINS_PER_AFR)));
    port->AFR[1] |=  ((uint32_t)(af & GPIO_AF_MSK) << (GPIO_AF_WIDTH * (offset - GPIO_PINS_PER_AFR)));
  }
}

int digitalRead(int gpio_pin) {
  GPIO_TypeDef * port = gpioPinToBase(gpio_pin);
  int offset = gpioPinOffset(gpio_pin);

  return (int) ((port->IDR >> offset) & 1UL);
}

void digitalWrite(int gpio_pin, int val) {
  GPIO_TypeDef * port = gpioPinToBase(gpio_pin);
  int offset = gpioPinOffset(gpio_pin);

  // BSRR
  if (val) port->BSRR = (1UL << offset);
  else     port->BSRR = (1UL << (offset + GPIO_BSRR_RESET_SHIFT));
}
