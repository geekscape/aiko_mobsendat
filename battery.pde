/* battery.pde
 * ~~~~~~~~~~~
 * Please do not remove the following notices.
 * License: GPLv3. http://geekscape.org/static/arduino_license.html
 * ----------------------------------------------------------------------------
 *
 * To Do
 * ~~~~~
 * - Put battery calibration constant into EEPROM.
 * - Is it cheaper to perform integer rather than floating arithmetic here ?
 */

const float BATTERY_CALIBRATION = 88.0f;

void batteryHandler() {
  float voltage = ((float) (analogRead(PIN_BATTERY_VOLTAGE) / BATTERY_CALIBRATION));

  globalString.begin();
  globalString  = "b:";
  globalString += voltage;

  sendMessage(globalString, LOG_SERIAL, LOG_STORAGE);
}
