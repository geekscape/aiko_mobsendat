/* aiko_modsendat.h
 * ~~~~~~~~~~~~~~~~
 * Please do not remove the following notices.
 * License: GPLv3. http://geekscape.org/static/arduino_license.html
 * ----------------------------------------------------------------------------
 *
 * To Do
 * ~~~~~
 * None, yet !
 */

#define DEFAULT_BAUD_RATE 38400

#define HEARTBEAT_PERIOD   250 // milliseconds (increase to 1 second for flight)

#define GLOBAL_BUFFER_SIZE 16

// Digital Input/Output pins
#define PIN_GPS_RX              0  // GPS and Arduino programming
#define PIN_GPS_TX              1  // GPS and Arduino programming
#define PIN_SERIAL_RX           2  // USB and ZigBee
#define PIN_SERIAL_TX           3  // USB and ZigBee
#define PIN_GPS_POWER           4  // GPS power enable (active high)
#define PIN_RADIOMETRIX_POWER   5  // Radiometrix power enable (active high)
#define PIN_ONE_WIRE            6  // OneWire bus for DS18B20 temperature
#define PIN_SD_CARD_DETECT      7  // Micro-SD card detect (active low)
#define PIN_D8                  8  // Unused
#define PIN_SD_CARD_SELECT      9  // Micro-SD card SPI select
#define PIN_ACCEL_SELECT       10  // Accelerometer SPI select
#define PIN_SPI_MISO           11  // SPI bus MISO
#define PIN_SPI_MISO           12  // SPI bus MOSI
#define PIN_SPI_SCK            13  // SPI bus SCK

// Analog Input pins
#define PIN_A0                  0  // Unused
#define PIN_BATTERY_VOLTAGE     1  // Resolution: 0.010V
#define PIN_A2                  2  // Unused
#define PIN_A3                  3  // Unused
#define PIN_I2C_SDA             4  // I2C bus SDA
#define PIN_I2C_SCL             5  // I2C bus SCL
