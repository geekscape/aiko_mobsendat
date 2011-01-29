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

#include "aiko_mobsendat.h"

void batteryHandler() {
  serial.println("battery");
}
