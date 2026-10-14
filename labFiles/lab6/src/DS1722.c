// DS1722.c
// Source code for the DS1722 temperature sensor

#include "DS1722.h"

static int resolution_bits = DS1722_MIN_BITS;   // matches the power-up config

// One transaction is CE high, an address byte, one or more data bytes, CE low.

static void ceHigh(void) { digitalWrite(DS1722_CE_PIN, 1); }
static void ceLow(void)  { digitalWrite(DS1722_CE_PIN, 0); }

static void writeRegister(uint8_t addr, uint8_t val) {
  ceHigh();
  spiSendReceive((char) addr);
  spiSendReceive((char) val);
  ceLow();
}

static uint8_t readRegister(uint8_t addr) {
  ceHigh();
  spiSendReceive((char) addr);
  uint8_t val = (uint8_t) spiSendReceive(0);      
  ceLow();
  return val;
}

static uint8_t configFor(int bits) {
  // 8 to 11 bits: R = 000 to 011, 12 bits: R = 100.
  return (uint8_t) (DS1722_CONFIG_FIXED | ((bits - DS1722_MIN_BITS) << DS1722_CONFIG_RES_POS));
}

int ds1722Init(int bits) {
  gpioEnable(gpioPinToPort(DS1722_CE_PIN));
  ceLow();                                        
  pinMode(DS1722_CE_PIN, GPIO_OUTPUT);

  if (initSPI(DS1722_SPI_BR, DS1722_SPI_CPOL, DS1722_SPI_CPHA) != 0) return -1;
  return ds1722SetResolution(bits);
}

int ds1722SetResolution(int bits) {
  if (bits < DS1722_MIN_BITS || bits > DS1722_MAX_BITS) return -1;

  uint8_t config = configFor(bits);
  writeRegister(DS1722_WRITE_CONFIG, config);

  // Read back
  if (ds1722ReadConfig() != config) return -1;

  resolution_bits = bits;
  return 0;
}

int ds1722Resolution(void) {
  return resolution_bits;
}

uint8_t ds1722ReadConfig(void) {
  return readRegister(DS1722_READ_CONFIG);
}

float ds1722ReadTemp(void) {
  ceHigh();
  spiSendReceive(DS1722_TEMP_LSB);
  uint8_t lsb = (uint8_t) spiSendReceive(0);
  uint8_t msb = (uint8_t) spiSendReceive(0);
  ceLow();
  uint16_t mask = (uint16_t) (0xFFFFU << (DS1722_TEMP_BITS - resolution_bits));
  int16_t  raw  = (int16_t) ((((uint16_t) msb << 8) | lsb) & mask);
  return (float) raw / DS1722_LSB_PER_C;
}

uint32_t ds1722ConversionMs(int bits) {
  if (bits < DS1722_MIN_BITS) bits = DS1722_MIN_BITS;
  if (bits > DS1722_MAX_BITS) bits = DS1722_MAX_BITS;
  return DS1722_CONV_MS_8BIT << (bits - DS1722_MIN_BITS);
}
