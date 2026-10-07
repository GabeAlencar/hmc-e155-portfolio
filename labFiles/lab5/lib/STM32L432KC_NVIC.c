// STM32L432KC_NVIC.c
// Source code for NVIC and CPU interrupt functions

#include "STM32L432KC_NVIC.h"

void nvicEnableIRQ(int irq_num) {
  if (irq_num < 0 || irq_num >= NVIC_MAX_IRQS) return;

  // Write-1-to-set: zeros leave the other IRQs alone, so no read-modify-write
  NVIC->ISER[irq_num / NVIC_IRQS_PER_REG] = 1UL << (irq_num % NVIC_IRQS_PER_REG);
}

void enableInterrupts(void) {
  // Clear PRIMASK so the CPU takes interrupts (same as CMSIS __enable_irq())
  __asm volatile ("cpsie i" : : : "memory");
}
