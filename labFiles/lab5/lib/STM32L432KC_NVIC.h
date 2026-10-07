// STM32L432KC_NVIC.h
// Nested vectored interrupt controller (NVIC) registers and functions.
//
// The NVIC is part of the Cortex-M4 core, so its registers are documented in
// the programming manual (PM0214 section 4.3), not in RM0394. NVIC bits are
// indexed by an interrupt's position in the vector table, not by EXTI line.

#ifndef STM32L4_NVIC_H
#define STM32L4_NVIC_H

#include <stdint.h>

#ifndef __IO
#define __IO volatile
#endif

// Base address

#define NVIC_BASE (0xE000E100UL)

// Register map (offsets from the PM0214 NVIC register map, relative to NVIC_BASE)

typedef struct {
  __IO uint32_t ISER[8];       // 0x000 Interrupt set-enable
  uint32_t      RESERVED0[24];
  __IO uint32_t ICER[8];       // 0x080 Interrupt clear-enable
  uint32_t      RESERVED1[24];
  __IO uint32_t ISPR[8];       // 0x100 Interrupt set-pending
  uint32_t      RESERVED2[24];
  __IO uint32_t ICPR[8];       // 0x180 Interrupt clear-pending
  uint32_t      RESERVED3[24];
  __IO uint32_t IABR[8];       // 0x200 Interrupt active bit
  uint32_t      RESERVED4[56];
  __IO uint8_t  IPR[240];      // 0x300 Interrupt priority, one byte per IRQ
} NVIC_TypeDef;

#define NVIC ((NVIC_TypeDef *) NVIC_BASE)

// Definitions

#define NVIC_IRQS_PER_REG 32
#define NVIC_MAX_IRQS     240

// IRQ numbers: position in the vector table (RM0394 Table 46)
#define EXTI0_IRQ_NUM     6
#define EXTI1_IRQ_NUM     7
#define EXTI2_IRQ_NUM     8
#define EXTI3_IRQ_NUM     9
#define EXTI4_IRQ_NUM     10
#define EXTI9_5_IRQ_NUM   23
#define TIM2_IRQ_NUM      28
#define EXTI15_10_IRQ_NUM 40
#define TIM6_DAC_IRQ_NUM  54
#define TIM7_IRQ_NUM      55
#define LPTIM1_IRQ_NUM    65

// Function prototypes

void nvicEnableIRQ(int irq_num);
void enableInterrupts(void);

#endif
