// main.c
// E155 Lab 5: Interrupts

#include "main.h"

// print one sample
static void printSample(VelocitySample sample) {
  printf("Speed: %6.3f rev/s   Direction: %s\n",
         fabsf(sample.rev_per_s), velocityDirection(sample));
}

int main(void) {
  // 16 MHz system clock from HSI16
  configureClock();

  printf("E155 Lab 5: 25GA370 1:%d motor, %d PPR, %d counts/rev\n",
         MOTOR_GEAR_RATIO, ENCODER_PPR, ENCODER_COUNTS_PER_REV);
  printf("Starting the 32.768 kHz crystal (about 2 s)...\n");

  // encoder interrupts
  if (encoderInit() != 0 || velocityInit() != 0) {
    printf("Error: invalid encoder pin or sample period\n");
    while (1);
  }
  __enable_irq();

  printf("Updating every %d ms, timed by the %s\n", SAMPLE_PERIOD_MS, velocityTimeBase());
  printf("CW/CCW is looking at the end of the output shaft\n");

  while (1) {
    if (velocitySampleReady()) {
      printSample(velocityGetSample());
    }
  }
}
