// STM32L432KC_SPI.c
// Source code for SPI functions

#include "STM32L432KC.h"

static void configureSPIPin(int gpio_pin) {
  gpioEnable(gpioPinToPort(gpio_pin));
  pinAltFunction(gpio_pin, SPI_AF);             
  pinMode(gpio_pin, GPIO_ALT);
}

int initSPI(int br, int cpol, int cpha) {
  if (br < 0 || br > SPI_BR_MAX) return -1;
  if ((cpol != 0 && cpol != 1) || (cpha != 0 && cpha != 1)) return -1;

  RCC->APB2ENR |= RCC_APB2ENR_SPI1EN;
  (void) RCC->APB2ENR;                         

  configureSPIPin(SPI_SCK_PIN);
  configureSPIPin(SPI_MISO_PIN);
  configureSPIPin(SPI_MOSI_PIN);

  // CR1 and CR2 are written while SPE = 0
  SPI1->CR1 = 0;

  // Controller, clock divider, mode, MSB first, full duplex.
  SPI1->CR1 = ((uint32_t) br << SPI_CR1_BR_Pos)
            | ((uint32_t) cpol << SPI_CR1_CPOL_Pos)
            | ((uint32_t) cpha << SPI_CR1_CPHA_Pos)
            | SPI_CR1_MSTR | SPI_CR1_SSM | SPI_CR1_SSI;

  // 8-bit frames
  SPI1->CR2 = ((uint32_t) SPI_DS_8BIT << SPI_CR2_DS_Pos) | SPI_CR2_FRXTH;

  SPI1->CR1 |= SPI_CR1_SPE;
  return 0;
}

char spiSendReceive(char send) {
  // DR must be accessed as a byte
  volatile uint8_t * dr = (volatile uint8_t *) &SPI1->DR;

  while ((SPI1->SR & SPI_SR_TXE) == 0);
  *dr = (uint8_t) send;

  // RXNE is set after the 8th SCK edge
  while ((SPI1->SR & SPI_SR_RXNE) == 0);
  return (char) *dr;
}
