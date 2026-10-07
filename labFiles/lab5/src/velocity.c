// velocity.c
// Source code for velocity measurement
//   rev/s = counts / (ENCODER_COUNTS_PER_REV * window in s)

#include "velocity.h"
#include "encoder.h"

// Window length in LSE ticks: 32768 * 500 / 1000 = 16384, exactly 0.5 s
#define LSE_TICKS_PER_WINDOW (LSE_FREQ * SAMPLE_PERIOD_MS / MS_PER_S)

// Shared between the timer handlers and the main program
static volatile int32_t  window_counts = 0;
static volatile int      sample_ready  = 0;
static volatile uint32_t last_position = 0;

// Only used by the main program
static const char * time_base = "no timer";

static float countsToRevPerSec(int32_t counts) {
  return (float) counts * MS_PER_S / ((float) ENCODER_COUNTS_PER_REV * SAMPLE_PERIOD_MS);
}

// Start the LSE crystal and wait for it
static int startCrystal(void) {
  enableTIMClock(LSE_WAIT_TIM);
  initTIM(LSE_WAIT_TIM);
  startLSE();

  for (uint32_t waited_ms = 0; !lseReady(); waited_ms += LSE_POLL_MS) {
    if (waited_ms >= LSE_TIMEOUT_MS) return -1;
    delay_millis(LSE_WAIT_TIM, LSE_POLL_MS);
  }
  return 0;
}

static int startCrystalWindow(void) {
  if (startCrystal() != 0) return -1;

  last_position = encoderPosition();
  if (initPeriodicLPTIM(VELOCITY_LPTIM, LSE_TICKS_PER_WINDOW) != 0) return -1;
  NVIC_EnableIRQ(VELOCITY_LPTIM_IRQn);
  return 0;
}

static int startRCWindow(void) {
  enableTIMClock(VELOCITY_TIM);

  last_position = encoderPosition();
  if (initPeriodicTIM(VELOCITY_TIM, SAMPLE_PERIOD_MS) != 0) return -1;
  NVIC_EnableIRQ(VELOCITY_TIM_IRQn);
  return 0;
}

int velocityInit(void) {
  if (startCrystalWindow() == 0) {
    time_base = "LSE 32.768 kHz crystal (LPTIM1)";
    return 0;
  }
  if (startRCWindow() == 0) {
    time_base = "HSI16 RC oscillator (TIM6), crystal timer unavailable";
    return 0;
  }
  return -1;
}

int velocitySampleReady(void) {
  return sample_ready;
}

VelocitySample velocityGetSample(void) {
  VelocitySample sample;

  sample_ready     = 0;
  sample.counts    = window_counts;    
  sample.rev_per_s = countsToRevPerSec(sample.counts);
  return sample;
}

const char * velocityDirection(VelocitySample sample) {
  if (sample.counts > 0) return "CW";
  if (sample.counts < 0) return "CCW";
  return "stopped";
}

const char * velocityTimeBase(void) {
  return time_base;
}

// Interrupt handlers

static void takeSample(void) {
  uint32_t position = encoderPosition();
  window_counts = (int32_t) (position - last_position);
  last_position = position;
  sample_ready  = 1;
}

void VELOCITY_LPTIM_IRQHandler(void) {
  if (lptimUpdatePending(VELOCITY_LPTIM)) {
    lptimClearUpdate(VELOCITY_LPTIM);
    takeSample();
  }
}

void VELOCITY_TIM_IRQHandler(void) {
  if (timUpdatePending(VELOCITY_TIM)) {
    timClearUpdate(VELOCITY_TIM);
    takeSample();
  }
}
