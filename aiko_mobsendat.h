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

const int DEFAULT_BAUD_RATE = 38400;

const int HEARTBEAT_PERIOD = 250;  // milliseconds (increase to 1 second for flight)

const int GLOBAL_BUFFER_SIZE = 32;

// Digital Input/Output pins
const int PIN_GPS_RX =            0;  // GPS and Arduino programming
const int PIN_GPS_TX =            1;  // GPS and Arduino programming
const int PIN_SERIAL_RX =         2;  // USB and ZigBee
const int PIN_SERIAL_TX =         3;  // USB and ZigBee
const int PIN_GPS_POWER =         4;  // GPS power enable (active high)
const int PIN_RADIOMETRIX_POWER=  5;  // Radiometrix power enable (active high)
const int PIN_ONE_WIRE =          6;  // OneWire bus for DS18B20 temperature
const int PIN_SD_CARD_DETECT =    7;  // Micro-SD card detect (active low)
const int PIN_D8 =                8;  // Unused
const int PIN_SD_CARD_SELECT =    9;  // Micro-SD card SPI select
const int PIN_ACCEL_SELECT =     10;  // Accelerometer SPI select
const int PIN_SPI_MISO =         11;  // SPI bus MISO
const int PIN_SPI_MOSI =         12;  // SPI bus MOSI
const int PIN_SPI_SCK =          13;  // SPI bus SCK

// Analog Input pins
const int PIN_A0 =                0;  // Unused
const int PIN_BATTERY_VOLTAGE =   1;  // Resolution: 0.010V
const int PIN_A2 =                2;  // Unused
const int PIN_A3 =                3;  // Unused
const int PIN_I2C_SDA =           4;  // I2C bus SDA
const int PIN_I2C_SCL =           5;  // I2C bus SCL
