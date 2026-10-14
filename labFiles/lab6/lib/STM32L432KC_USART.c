// STM32L432KC_USART.c
// Source code for USART functions

#include "STM32L432KC.h"

// USARTDIV must be at least 16 with 16x oversampling (RM0394 38.5.5)
#define USART_BRR_MIN 16UL
#define USART_BRR_MAX 0xFFFFUL

static void configureUSARTPin(int gpio_pin, int af) {
  gpioEnable(gpioPinToPort(gpio_pin));
  pinAltFunction(gpio_pin, af);
  pinMode(gpio_pin, GPIO_ALT);
}

int initUSART(USART_TypeDef * USARTx, uint32_t baud) {
  if (baud == 0) return -1;
  uint32_t brr = (HSI16_FREQ + baud / 2) / baud;  // round to the nearest divider
  if (brr < USART_BRR_MIN || brr > USART_BRR_MAX) return -1;

  enableHSI16();                                   // kernel clock, independent of SYSCLK

  if (USARTx == USART1) {
    RCC->APB2ENR |= RCC_APB2ENR_USART1EN;
    (void) RCC->APB2ENR;                           // read back so the clock is on before USART1 is written
    RCC->CCIPR = (RCC->CCIPR & ~RCC_CCIPR_USART1SEL_Msk) | (USARTSEL_HSI16 << RCC_CCIPR_USART1SEL_Pos);

    configureUSARTPin(USART1_TX_PIN, USART1_AF);
    configureUSARTPin(USART1_RX_PIN, USART1_AF);
  } else if (USARTx == USART2) {
    RCC->APB1ENR1 |= RCC_APB1ENR1_USART2EN;
    (void) RCC->APB1ENR1;
    RCC->CCIPR = (RCC->CCIPR & ~RCC_CCIPR_USART2SEL_Msk) | (USARTSEL_HSI16 << RCC_CCIPR_USART2SEL_Pos);

    configureUSARTPin(USART2_TX_PIN, USART2_TX_AF);
    configureUSARTPin(USART2_RX_PIN, USART2_RX_AF);
  } else {
    return -1;
  }

  // CR1, CR2 and BRR are written while UE = 0
  USARTx->CR1 = 0;                                 // M = 00: 8 data bits, no parity, OVER8 = 0: 16x oversampling
  USARTx->CR2 &= ~USART_CR2_STOP;                  // 1 stop bit

  // Tx/Rx baud = f_CK / USARTDIV: 16 MHz / 128 = 125000 exactly
  USARTx->BRR = brr;

  USARTx->CR1 |= USART_CR1_UE;
  USARTx->CR1 |= USART_CR1_TE | USART_CR1_RE;
  return 0;
}

void sendChar(USART_TypeDef * USARTx, char data) {
  while ((USARTx->ISR & USART_ISR_TXE) == 0);
  USARTx->TDR = (uint8_t) data;
}

void sendString(USART_TypeDef * USARTx, const char * str) {
  while (*str != '\0') sendChar(USARTx, *str++);

  while ((USARTx->ISR & USART_ISR_TC) == 0);       // last byte fully shifted out
}

int usartCharReady(USART_TypeDef * USARTx) {
  return (USARTx->ISR & USART_ISR_RXNE) != 0;
}

char readChar(USART_TypeDef * USARTx) {
  // Clear an earlier overrun (a byte arrived before RDR was read) so reception continues
  if (USARTx->ISR & USART_ISR_ORE) USARTx->ICR = USART_ICR_ORECF;

  while (!usartCharReady(USARTx));
  return (char) USARTx->RDR;                       // reading RDR clears RXNE
}
