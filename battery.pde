/* battery.c
 * ~~~~~~~~~
 * Please do not remove the following notices.
 * License: GPLv3. http://geekscape.org/static/arduino_license.html
 * ----------------------------------------------------------------------------
 *
 * To Do
 * ~~~~~
 * - None, yet.
 */

void batteryHandler() {
  float voltage = 0.0;
  voltage = ((float)(analogRead(PIN_BATTERY_VOLTAGE) / (float)88));
  serial.print("b:");
  serial.println(voltage);
}
