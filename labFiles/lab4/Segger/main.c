// main.c
// E155 Lab 4: Digital Audio

#include "STM32L432KC.h"

#define SPEAKER_PIN    PA8   
#define SPEAKER_AF     1   

#define PWM_TIMER      TIM1
#define DELAY_TIMER    TIM2

#define SONG_GAP_MS     1500 // silence between songs

// Pitch in Hz, duration in ms
const int notes[][2] = {
{659,	125},
{623,	125},
{659,	125},
{623,	125},
{659,	125},
{494,	125},
{587,	125},
{523,	125},
{440,	250},
{  0,	125},
{262,	125},
{330,	125},
{440,	125},
{494,	250},
{  0,	125},
{330,	125},
{416,	125},
{494,	125},
{523,	250},
{  0,	125},
{330,	125},
{659,	125},
{623,	125},
{659,	125},
{623,	125},
{659,	125},
{494,	125},
{587,	125},
{523,	125},
{440,	250},
{  0,	125},
{262,	125},
{330,	125},
{440,	125},
{494,	250},
{  0,	125},
{330,	125},
{523,	125},
{494,	125},
{440,	250},
{  0,	125},
{494,	125},
{523,	125},
{587,	125},
{659,	375},
{392,	125},
{699,	125},
{659,	125},
{587,	375},
{349,	125},
{659,	125},
{587,	125},
{523,	375},
{330,	125},
{587,	125},
{523,	125},
{494,	250},
{  0,	125},
{330,	125},
{659,	125},
{  0,	250},
{659,	125},
{1319,	125},
{  0,	250},
{623,	125},
{659,	125},
{  0,	250},
{623,	125},
{659,	125},
{623,	125},
{659,	125},
{623,	125},
{659,	125},
{494,	125},
{587,	125},
{523,	125},
{440,	250},
{  0,	125},
{262,	125},
{330,	125},
{440,	125},
{494,	250},
{  0,	125},
{330,	125},
{416,	125},
{494,	125},
{523,	250},
{  0,	125},
{330,	125},
{659,	125},
{623,	125},
{659,	125},
{623,	125},
{659,	125},
{494,	125},
{587,	125},
{523,	125},
{440,	250},
{  0,	125},
{262,	125},
{330,	125},
{440,	125},
{494,	250},
{  0,	125},
{330,	125},
{523,	125},
{494,	125},
{440,	500},
{  0,	0}};

// Happy Birthday
const int happy_birthday[][2] = {
  {392,  300}, {392,  100},                             // G4 G4 
  {440,  400}, {392,  400}, {523,  400},                // A4 G4 C5  
  {494,  800}, {392,  300}, {392,  100},                // G4 G4  
  {440,  400}, {392,  400}, {587,  400},                // A4 G4 D5 
  {523,  800}, {392,  300}, {392,  100},                // C5 G4 G4 
  {784,  400}, {659,  400}, {523,  400},                // G5 E5 C5 
  {494,  400}, {440,  400}, {698,  300}, {698,  100},   // B4 A4 F5 F5 
  {659,  400}, {523,  400}, {587,  400},                // E5 C5 D5 
  {523, 1200},                                          // C5  
  {  0,    0}};

// Play a score until a duration of 0 
static void playSong(const int song[][2], uint32_t gap_ms) {
  for (int i = 0; song[i][1] > 0; i++) {
    uint32_t freq = (song[i][0] > 0) ? (uint32_t) song[i][0] : 0;   
    uint32_t dur  = (uint32_t) song[i][1];
    uint32_t gap  = (freq != 0 && gap_ms < dur) ? gap_ms : 0;        

    setPWMFreq(PWM_TIMER, freq);     
    delay_millis(DELAY_TIMER, dur - gap); 

    if (gap) {
      setPWMFreq(PWM_TIMER, 0);
      delay_millis(DELAY_TIMER, gap);
    }
  }
  setPWMFreq(PWM_TIMER, 0);         
}

int main(void) {
  // 16 MHz system clock from HSI16
  configureClock();

  // Peripheral clocks
  gpioEnable(GPIO_PORT_A);
  RCC->APB2ENR  |= RCC_APB2ENR_TIM1EN;
  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;
  (void) RCC->APB1ENR1; 
                          
  // PA8 -> TIM1_CH1
  pinAltFunction(SPEAKER_PIN, SPEAKER_AF);
  pinMode(SPEAKER_PIN, GPIO_ALT);

  // Timers
  initPWM(PWM_TIMER);
  initTIM(DELAY_TIMER);

  while (1) {
    playSong(notes, 0);         
    delay_millis(DELAY_TIMER, SONG_GAP_MS);
    playSong(happy_birthday, 0);
    delay_millis(DELAY_TIMER, SONG_GAP_MS);
  }
}
