// DS1722.h
// DS1722 digital thermometer over SPI (SERMODE tied to VDD).

#ifndef DS1722_H
#define DS1722_H

#include <stdint.h>
#include "STM32L432KC.h"

// Chip enable, active high
#define DS1722_CE_PIN        PB0        // Nucleo D3

// SPI: 16 MHz / 2^(2+1) = 2 MHz
#define DS1722_SPI_BR        0b010
#define DS1722_SPI_CPOL      0
#define DS1722_SPI_CPHA      1

// Register addresses
#define DS1722_READ_CONFIG   0x00
#define DS1722_WRITE_CONFIG  0x80
#define DS1722_TEMP_LSB      0x01
#define DS1722_TEMP_MSB      0x02

// Configuration register: 1 1 1 1SHOT R2 R1 R0 SD
#define DS1722_CONFIG_FIXED  0xE0      
#define DS1722_CONFIG_RES_POS 1
#define DS1722_CONFIG_SD     0x01     

// Resolution
#define DS1722_MIN_BITS      8
#define DS1722_MAX_BITS      12

// Max conversion time 1200 ms (12 bit)
#define DS1722_CONV_MS_8BIT  75UL

// Temperature register
#define DS1722_LSB_PER_C     256.0f
#define DS1722_TEMP_BITS     16

// Function prototypes

int      ds1722Init(int bits);            
int      ds1722SetResolution(int bits);    
int      ds1722Resolution(void);
uint8_t  ds1722ReadConfig(void);
float    ds1722ReadTemp(void);              
uint32_t ds1722ConversionMs(int bits);

#endif
