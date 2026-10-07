// encoder.c
// Source code for quadrature encoder decoding (x4: every edge of A and B)

#include "encoder.h"

// State is (A << 1) | B. With A leading B: 00 -> 10 -> 11 -> 01 -> 00
#define STATE_A_SHIFT 1
#define STATE_BITS    2
#define NUM_STATES    4

// Steps for each transition (+1 is one count toward CW)
#define STEP_NONE     0
#define STEP_A_LEADS  (ENCODER_CW_SIGN)
#define STEP_B_LEADS  (-(ENCODER_CW_SIGN))
#define STEP_SKIP     2         // both channels changed: an edge was missed

// Indexed by (previous state << STATE_BITS) | new state
static const int8_t STEP_TABLE[NUM_STATES * NUM_STATES] = {
  // new: 00         01            10            11
  STEP_NONE,    STEP_B_LEADS, STEP_A_LEADS, STEP_SKIP,      // previous 00
  STEP_A_LEADS, STEP_NONE,    STEP_SKIP,    STEP_B_LEADS,   // previous 01
  STEP_B_LEADS, STEP_SKIP,    STEP_NONE,    STEP_A_LEADS,   // previous 10
  STEP_SKIP,    STEP_A_LEADS, STEP_B_LEADS, STEP_NONE,      // previous 11
};

// Shared with the interrupt handlers
static volatile uint32_t position      = 0;   // unsigned so it wraps cleanly
static volatile uint32_t invalid_count = 0;   // missed edges (view in the debugger Watch window)
static volatile uint8_t  prev_state    = 0;

static uint8_t readState(void) {
  return (uint8_t) ((digitalRead(ENCODER_A_PIN) << STATE_A_SHIFT) | digitalRead(ENCODER_B_PIN));
}

// Count one step from the previous state to the current one
static void updatePosition(void) {
  uint8_t state = readState();
  int8_t  step  = STEP_TABLE[(prev_state << STATE_BITS) | state];

  if (step == STEP_SKIP) invalid_count++;
  else                   position += (uint32_t) step;   // -1 wraps to subtract 1

  prev_state = state;
}

static void configureInput(int gpio_pin) {
  gpioEnable(gpioPinToPort(gpio_pin));
  pinMode(gpio_pin, GPIO_INPUT);
  pinResistor(gpio_pin, GPIO_PULL_NONE);         
}

int encoderInit(void) {
  configureInput(ENCODER_A_PIN);
  configureInput(ENCODER_B_PIN);

  // Unmask EXTI, read the start state, then enable the NVIC so no edge is missed
  if (extiEnableInterrupt(ENCODER_A_PIN, EXTI_BOTH_EDGES) != 0) return -1;
  if (extiEnableInterrupt(ENCODER_B_PIN, EXTI_BOTH_EDGES) != 0) return -1;
  prev_state = readState();

  NVIC_EnableIRQ(ENCODER_A_IRQn);
  NVIC_EnableIRQ(ENCODER_B_IRQn);
  return 0;
}

uint32_t encoderPosition(void) {
  return position;
}

// Interrupt handlers: clear the pending bit first so a new edge is not lost

void ENCODER_A_IRQHandler(void) {
  if (extiPending(ENCODER_A_PIN)) {
    extiClearPending(ENCODER_A_PIN);
    updatePosition();
  }
}

void ENCODER_B_IRQHandler(void) {
  if (extiPending(ENCODER_B_PIN)) {
    extiClearPending(ENCODER_B_PIN);
    updatePosition();
  }
}
