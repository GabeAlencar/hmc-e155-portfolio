// STM32L432KC_EXTI.c
// Source code for SYSCFG/EXTI functions

#include "STM32L432KC_EXTI.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_RCC.h"

static void enableSYSCFGClock(void) {
  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
  (void) RCC->APB2ENR;                             // read back so the clock is on before EXTICR is written
}

int extiEnableInterrupt(int gpio_pin, int edges) {
  int port = gpioPinToPort(gpio_pin);
  if (gpio_pin < 0 || port > GPIO_PORT_C) return -1;         // not a pin this driver knows
  if (edges == 0 || (edges & ~EXTI_BOTH_EDGES)) return -1;   // no valid edge selected

  int line = gpioPinOffset(gpio_pin);              // PAn, PBn, and PCn all share EXTI line n
  uint32_t line_mask = 1UL << line;
  int reg   = line / SYSCFG_EXTICR_LINES_PER_REG;
  int shift = SYSCFG_EXTICR_FIELD_WIDTH * (line % SYSCFG_EXTICR_LINES_PER_REG);

  // SYSCFG: route this pin's port to EXTI line n
  enableSYSCFGClock();
  SYSCFG->EXTICR[reg] &= ~(SYSCFG_EXTICR_FIELD_MSK << shift);
  SYSCFG->EXTICR[reg] |=  ((uint32_t) port << shift);

  // EXTI: select the edges
  if (edges & EXTI_RISING_EDGE)  EXTI->RTSR1 |= line_mask;
  else                           EXTI->RTSR1 &= ~line_mask;
  if (edges & EXTI_FALLING_EDGE) EXTI->FTSR1 |= line_mask;
  else                           EXTI->FTSR1 &= ~line_mask;

  // Drop any stale request, then unmask the line
  EXTI->PR1   = line_mask;
  EXTI->IMR1 |= line_mask;
  return 0;
}

int extiPending(int gpio_pin) {
  return (EXTI->PR1 & (1UL << gpioPinOffset(gpio_pin))) != 0;
}

void extiClearPending(int gpio_pin) {
  // Write 1 to clear
  EXTI->PR1 = 1UL << gpioPinOffset(gpio_pin);
}
