// main.c
// E155 Lab 6: The Internet of Things and Serial Peripheral Interface
// Web page (through the ESP8266) that shows the DS1722 temperature and controls an LED

#include "main.h"

/////////////////////////////////////////////////////////////////
// Provided Constants and Functions
/////////////////////////////////////////////////////////////////

// Kept between requests, so loading the page without a command changes nothing
static int led_status = 0;
static int res_bits   = DEFAULT_RES_BITS;
static int sensor_ok  = 0;

// Determines whether a given character sequence is in a char array request, returning 1 if present, -1 if not present
static int inString(const char request[], const char des[]) {
  if (strstr(request, des) != NULL) {return 1;}
  return -1;
}

// Turns the LED on or off if the request asks for it, and returns the LED state
static int updateLEDStatus(const char request[]) {
  if (inString(request, REQ_LED_OFF) == 1) {
    digitalWrite(LED_PIN, 0);
    led_status = 0;
  } else if (inString(request, REQ_LED_ON) == 1) {
    digitalWrite(LED_PIN, 1);
    led_status = 1;
  }

  return led_status;
}

// Read one request from the ESP8266: "/REQ:<tag>\n"
static void readRequest(char * request, int len) {
  int  i = 0;
  char c;

  do {
    c = readChar(ESP_USART);
    if (i < len - 1) request[i++] = c;             // drop extra characters but keep waiting for '\n'
  } while (c != '\n');

  request[i] = '\0';
}

/////////////////////////////////////////////////////////////////
// Solution Functions
/////////////////////////////////////////////////////////////////

// Changes the DS1722 resolution if the request asks for it
static void updateResolution(const char request[]) {
  const char * bits_str = strstr(request, REQ_RES_BITS);

  if (bits_str != NULL) {
    int bits = atoi(bits_str + strlen(REQ_RES_BITS));
    if (bits >= DS1722_MIN_BITS && bits <= DS1722_MAX_BITS) res_bits = bits;   // ignore anything else
    sensor_ok = (ds1722SetResolution(res_bits) == 0);
  }

  // Retry until the sensor answers (e.g. it was plugged in after reset)
  if (!sensor_ok) sensor_ok = (ds1722SetResolution(res_bits) == 0);
}

int main(void) {
  char request[REQUEST_LEN];

  // 16 MHz system clock from HSI16
  configureClock();

  gpioEnable(gpioPinToPort(LED_PIN));
  digitalWrite(LED_PIN, 0);
  pinMode(LED_PIN, GPIO_OUTPUT);

  if (initUSART(ESP_USART, ESP_BAUD) != 0) {
    printf("Error: invalid USART or baud rate\n");
    while (1);
  }

  // SPI initialization (initSPI() is called inside ds1722Init()):
  // continuous conversion, then wait for the first one so the first page has a reading
  sensor_ok = (ds1722Init(res_bits) == 0);
  enableTIMClock(STARTUP_TIM);
  initTIM(STARTUP_TIM);
  delay_millis(STARTUP_TIM, ds1722ConversionMs(res_bits));

  printf("E155 Lab 6: DS1722 %s, config 0x%02X\n",
         sensor_ok ? "ready" : "not responding", ds1722ReadConfig());

  while (1) {
    // Wait for ESP8266 to send a request, which ends with '\n'
    readRequest(request, REQUEST_LEN);

    // SPI code for reading temperature
    updateResolution(request);
    float temp_c = ds1722ReadTemp();

    // Update string with current LED state
    int led_on = updateLEDStatus(request);

    PageState state = {
      .temp_c    = temp_c,
      .led_on    = led_on,
      .res_bits  = res_bits,
      .sensor_ok = sensor_ok,
    };
    // finally, transmit the webpage over UART
    sendWebpage(ESP_USART, state);

    printf("%s", request);                         // each request ends with '\n'
  }
}
