// velocity.h
// Motor velocity from the encoder count over a fixed sample window.

#ifndef VELOCITY_H
#define VELOCITY_H

#include <stdint.h>
#include "STM32L432KC.h"

// Sample window timer: LPTIM1 on the LSE crystal
#define VELOCITY_LPTIM            LPTIM1
#define VELOCITY_LPTIM_IRQn       LPTIM1_IRQn
#define VELOCITY_LPTIM_IRQHandler LPTIM1_IRQHandler

// Fallback if the crystal does not start: TIM6 on HSI16 (~1 % accurate)
#define VELOCITY_TIM              TIM6
#define VELOCITY_TIM_IRQn         TIM6_DAC_IRQn
#define VELOCITY_TIM_IRQHandler   TIM6_DAC_IRQHandler

// LSE crystal start-up (about 2 s typical), timed with TIM2
#define LSE_FREQ                  32768UL
#define LSE_WAIT_TIM              TIM2
#define LSE_TIMEOUT_MS            5000
#define LSE_POLL_MS               10

// Window length = display update period (2 Hz). Must be a multiple of 125 ms.
#define SAMPLE_PERIOD_MS          500

typedef struct {
  int32_t counts;       // net encoder counts in the window, + = CW
  float   rev_per_s;    // signed angular velocity, + = CW
} VelocitySample;

// Function prototypes

int            velocityInit(void);   // 0 on success, -1 if neither timer could start
int            velocitySampleReady(void);
VelocitySample velocityGetSample(void);
const char *   velocityDirection(VelocitySample sample);
const char *   velocityTimeBase(void);

// Interrupt handlers
void VELOCITY_LPTIM_IRQHandler(void);
void VELOCITY_TIM_IRQHandler(void);

#endif
