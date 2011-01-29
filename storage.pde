/* storage.pde
 * ~~~~~~~~~~~
 * Please do not remove the following notices.
 * License: GPLv3. http://geekscape.org/static/arduino_license.html
 * ----------------------------------------------------------------------------
 *
 * To Do
 * ~~~~~
 * - None, yet.
 */

Sd2Card  card;
SdVolume volume;
SdFile   root;
SdFile   file;

void storageInitialize() {
/*
  if (digitalRead(PIN_SD_CARD_DETECT))
  {
    error("microSD card is not inserted!");
  }
  else
  {
    PRNln("microSD card inserted.");
  }
  if (!card.init(SPI_HALF_SPEED, PIN_SD_CARD_SELECT)) error("card.init");
  // initialize a FAT volume
  if (!volume.init(card)) error("volume.init");
  // open root directory
  if (!root.openRoot(volume)) error("openRoot");

  // create a new file
  char name[] = "LOGGER00.CSV";

  // Makes a new incremented filename every time you boot
  for (uint8_t i = 0; i < 100; i++)
  {
    name[6] = i/10 + '0';
    name[7] = i%10 + '0';
    if (file.open(root, name, O_CREAT | O_EXCL | O_WRITE)) break;
  }

  if (!file.isOpen()) error("file.create");
  PRN("Logging to: ");
  PRNln(name);
  file.writeError = 0;
 */
}

void storageHandler() {
}

/*
#define CSV_COLS_HEADER                         \
  "millis,"                                     \
  CSV_COLS_RTC                                  \
  CSV_COLS_BPS                                  \
  CSV_COLS_DS1820                               \
  CSV_COLS_ACCEL                                \
  CSV_COLS_GPS                                  \
  "vcc"

// print(ln) to file and/or rs232
#if SERIAL_OUTPUT
  #if FILE_OUTPUT
    #define PRN(x...) do     \
      {                    \
        file.print(x);  \
        Serial.print(x);   \
      } while(0)
    #define PRNln(x...) do     \
      {                    \
        file.println(x);  \
        Serial.println(x);   \
      } while(0)
  #else
    #define PRN(x...) Serial.print(x)
    #define PRNln(x...) Serial.println(x)
  #endif
#else
  #if FILE_OUTPUT
    #define PRN(x...) file.print(x)
    #define PRNln(x...) file.println(x)
  #else
    #define PRN(x...)
    #define PRNln(x...)
  #endif
#endif

#define LEADING_ZERO(x)  do { if(x < 10) PRN('0');} while(0)
#define PRNLZ(x)         do {LEADING_ZERO(x);PRN(x,DEC);}while(0)

#define LOG(x...)        do {PRN(',');PRN(x);}while(0)
*/
