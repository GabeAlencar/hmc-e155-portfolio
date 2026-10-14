// STM32L432KC_USART.h
// USART functions (8N1, clocked from HSI16).

#ifndef STM32L4_USART_H
#define STM32L4_USART_H

#include <stdint.h>
#include <stm32l432xx.h>   // CMSIS: USART struct and bit definitions

// Pins
#define USART1_TX_PIN PA9           // Nucleo D1
#define USART1_RX_PIN PA10          // Nucleo D0
#define USART1_AF     7
#define USART2_TX_PIN PA2           // Nucleo A7 (also the ST-LINK virtual COM port)
#define USART2_RX_PIN PA15
#define USART2_TX_AF  7
#define USART2_RX_AF  3

// RCC_CCIPR USARTxSEL: kernel clock source
#define USARTSEL_HSI16 0b10

// Function prototypes

int  initUSART(USART_TypeDef * USARTx, uint32_t baud);   // 0 on success, -1 for a bad USART or baud
void sendChar(USART_TypeDef * USARTx, char data);
void sendString(USART_TypeDef * USARTx, const char * str);
int  usartCharReady(USART_TypeDef * USARTx);
char readChar(USART_TypeDef * USARTx);                    // waits for a byte

#endif
