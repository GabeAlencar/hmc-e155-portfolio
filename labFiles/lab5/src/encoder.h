// encoder.h
// Quadrature encoder decoding with EXTI interrupts on both edges of A and B.

#ifndef ENCODER_H
#define ENCODER_H

#include <stdint.h>
#include "STM32L432KC.h"

// Encoder pins
#define ENCODER_A_PIN        PB0             
#define ENCODER_A_IRQn       EXTI0_IRQn
#define ENCODER_A_IRQHandler EXTI0_IRQHandler
#define ENCODER_B_PIN        PB1               
#define ENCODER_B_IRQn       EXTI1_IRQn
#define ENCODER_B_IRQHandler EXTI1_IRQHandler

// G and PPR
#define MOTOR_GEAR_RATIO             34
#define ENCODER_PULSES_PER_MOTOR_REV 12
#define ENCODER_PPR                  (ENCODER_PULSES_PER_MOTOR_REV * MOTOR_GEAR_RATIO)

// 4 edges per pulse
#define ENCODER_EDGES_PER_PULSE      4
#define ENCODER_COUNTS_PER_REV       (ENCODER_PPR * ENCODER_EDGES_PER_PULSE)

// sign for ccw or cw
#define ENCODER_CW_SIGN              1

// Function prototypes

int      encoderInit(void);       
uint32_t encoderPosition(void);

// Interrupt handlers
void ENCODER_A_IRQHandler(void);
void ENCODER_B_IRQHandler(void);

#endif
