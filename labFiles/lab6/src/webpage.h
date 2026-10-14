// webpage.h
// HTML page sent to the ESP8266, which serves it to the browser.

#ifndef WEBPAGE_H
#define WEBPAGE_H

#include "STM32L432KC.h"

// Requests from the ESP8266 are "/REQ:<path>\n"
#define REQ_LED_ON   "ledon"
#define REQ_LED_OFF  "ledoff"
#define REQ_RES_BITS "bits="      

typedef struct {
  float temp_c;
  int   led_on;
  int   res_bits;      
  int   sensor_ok;     
} PageState;

// Function prototypes

void sendWebpage(USART_TypeDef * USARTx, PageState state);

#endif
