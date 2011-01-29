/* aiko_modsendat.pde
 * ~~~~~~~~~~~~~~~~~~
 * Please do not remove the following notices.
 * Version: 0.0
 * License: GPLv3. http://geekscape.org/static/arduino_license.html
 * Documentation:  http://geekscape.github.com/aiko_mobsendat
 * Documentation:  http://groups.google.com/group/aiko-platform
 * Documentation:  https://github.com/lukeweston/RocketInstrumentation
 * Documentation:  http://www.freetronics.com/products/mobsendat
 * ----------------------------------------------------------------------------
 *
 * Third-Party libraries
 * ~~~~~~~~~~~~~~~~~~~~~
 * These libraries are not included in the Arduino IDE and
 * need to be downloaded and installed separately.
 *
 * - Aiko framework
 *   https://github.com/geekscape/Aiko
 *
 * - NewSoftSerial (download is at the bottom of the web page)
 *   http://arduiniana.org/libraries/newsoftserial
 *
 * - PString
 *   http://arduiniana.org/libraries/pstring
 *
 * To Do
 * ~~~~~
 * - #define for feature enable / disable.
 * - Separate configuration include file.
 * - Logging to micro-SD storage.
 * - Battery monitor.
 * - One-wire temperature sensor.
 * - Barometric pressure and temperature.
 * - 3-axis accelerometer (SPI).
 * - Real Time Clock (write record to storage).
 *
 * Notes
 * ~~~~~
 * - Millisecond counter cycles after 9 hours, 6 minutes and 7 seconds (a very long rocket flight).
 */

#include <AikoEvents.h>

using namespace Aiko;

#define DEFAULT_BAUD_RATE 38400

#define HEARTBEAT_PERIOD   250 // milliseconds (increase to 1 second for flight)

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

#include <PString.h>
#define GLOBAL_BUFFER_SIZE 16

char globalBuffer[GLOBAL_BUFFER_SIZE];  // Store dynamically constructed strings
PString globalString(globalBuffer, sizeof(globalBuffer));

void setup() {
  serialInitialize();

  Events.addHandler(heartbeatHandler, HEARTBEAT_PERIOD);
  Events.addHandler(millisecondHandler, 1);
}

void loop() {
  Events.loop();
}

/* ------------------------------------------------------------------------- */

#include <NewSoftSerial.h>

#define DEFAULT_BAUD_RATE  38400

#define SERIAL_BUFFER_SIZE 128

byte serialInitialized = false;

NewSoftSerial serial = NewSoftSerial(PIN_SERIAL_RX, PIN_SERIAL_TX);

void serialInitialize(void) {
  serial.begin(DEFAULT_BAUD_RATE);
  serialInitialized = true;
}

/* ------------------------------------------------------------------------- */

int millisecondCounter = 0;
int secondCounter = 0;

void millisecondHandler(void) {
  if ((++ millisecondCounter) == 1000) {
    millisecondCounter = 0;

    ++ secondCounter;
  }
}

void heartbeatHandler(void) {
  serial.println(millisecondCounterAsString());

  if (serial.available() > 0) {
    int ch = serial.read();

    if (ch == 'r')  {
      resetCounter();
      serial.println("reset");
    }
  }
}

const char *millisecondCounterAsString() {
  globalString.begin();
  globalString  = "t:";
  globalString += secondCounter;
  globalString += ".";
  if (millisecondCounter < 10)  globalString += "0";
  if (millisecondCounter < 100) globalString += "0";
  globalString += millisecondCounter;
  return(globalString);
}

void resetCounter(void) {
  secondCounter = millisecondCounter = 0;
}

/* ------------------------------------------------------------------------- */

