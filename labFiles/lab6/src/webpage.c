// webpage.c
// Source code for the web page
//   The ESP8266 forwards the page once it sees "</html>", or after 200 ms of silence,
//   so the page is sent in one go and only ends with "</html>".

#include <stdio.h>
#include "webpage.h"
#include "DS1722.h"

#define LINE_LEN 128

char* webpageStart = "<!DOCTYPE html><html><head><title>E155 Lab 6</title>\
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
    </head>\
    <body><h1>E155 Lab 6: IoT Thermometer</h1>";
char* ledStr = "<p>LED Control:</p><form action=\"ledon\"><input type=\"submit\" value=\"Turn the LED on!\"></form>\
    <form action=\"ledoff\"><input type=\"submit\" value=\"Turn the LED off!\"></form>";
char* webpageEnd   = "</body></html>";

static int decimalPlaces(int bits) {
  return bits - DS1722_MIN_BITS;
}

static void sendTemperature(USART_TypeDef * USARTx, PageState state) {
  char line[LINE_LEN];
  int  places = decimalPlaces(state.res_bits);

  sendString(USARTx, "<h2>Temperature</h2>");
  if (state.sensor_ok) {
    snprintf(line, LINE_LEN, "<p class=\"temp\">%.*f &deg;C</p>", places, state.temp_c);
  } else {
    snprintf(line, LINE_LEN, "<p class=\"temp\">--</p><p>The DS1722 did not respond.</p>");
  }
  sendString(USARTx, line);

  snprintf(line, LINE_LEN, "<p>Resolution: %d bits (%.*f &deg;C)</p>",
           state.res_bits, places, 1.0f / (float) (1 << places));
  sendString(USARTx, line);
}

static void sendResolutionForm(USART_TypeDef * USARTx, PageState state) {
  char line[LINE_LEN];

  sendString(USARTx, "<form action=\"res\"><select name=\"bits\">");
  for (int bits = DS1722_MIN_BITS; bits <= DS1722_MAX_BITS; bits++) {
    snprintf(line, LINE_LEN, "<option value=\"%d\"%s>%d bits</option>",
             bits, (bits == state.res_bits) ? " selected" : "", bits);
    sendString(USARTx, line);
  }
  sendString(USARTx, "</select> <input type=\"submit\" value=\"Set resolution\"></form>");

  sendString(USARTx, "<p class=\"note\">Reload for a new reading.</p>");
}

void sendWebpage(USART_TypeDef * USARTx, PageState state) {
  char ledStatusStr[20];
  sprintf(ledStatusStr, state.led_on ? "LED is on!" : "LED is off!");

  sendString(USARTx, webpageStart);             
  sendString(USARTx, ledStr);                    

  sendString(USARTx, "<h2>LED Status</h2>");
  sendString(USARTx, "<p>");
  sendString(USARTx, ledStatusStr);
  sendString(USARTx, "</p>");

  sendTemperature(USARTx, state);
  sendResolutionForm(USARTx, state);

  sendString(USARTx, webpageEnd);
}
