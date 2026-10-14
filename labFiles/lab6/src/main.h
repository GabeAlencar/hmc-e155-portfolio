// main.h
// E155 Lab 6: The Internet of Things and Serial Peripheral Interface

#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "STM32L432KC.h"
#include "DS1722.h"
#include "webpage.h"

// LED: Nucleo LD3
#define LED_PIN          PB3

// ESP8266: TX/RX crossed to PA9 (D1) / PA10 (D0)
#define ESP_USART        USART1
#define ESP_BAUD         125000UL

// "/REQ:" + a tag such as "res?bits=12" + '\n' + '\0', with room to spare
#define REQUEST_LEN      64

// Resolution at power-up (12 bits: 0.0625 C)
#define DEFAULT_RES_BITS 12

// Waits for the first conversion at startup
#define STARTUP_TIM      TIM2

#endif
