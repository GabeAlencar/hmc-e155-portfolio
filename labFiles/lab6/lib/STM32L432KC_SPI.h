// STM32L432KC_SPI.h
// SPI1 controller functions (8-bit frames, MSB first, software chip enable).

#ifndef STM32L4_SPI_H
#define STM32L4_SPI_H

#include <stdint.h>
#include <stm32l432xx.h>   // CMSIS: SPI struct and bit definitions

// Pins: SPI1 is AF5 on all three
#define SPI_SCK_PIN  PA5            // Nucleo A4
#define SPI_MISO_PIN PA6            // Nucleo A5 
#define SPI_MOSI_PIN PB5            // Nucleo D11
#define SPI_AF       5

// SPI_CR1 BR
#define SPI_BR_MAX   0b111

// SPI_CR2 DS
#define SPI_DS_8BIT  0b0111

// Function prototypes

int  initSPI(int br, int cpol, int cpha); 
char spiSendReceive(char send);            

#endif
