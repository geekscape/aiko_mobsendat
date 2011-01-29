/* storage.pde
 * ~~~~~~~~~~~
 * Please do not remove the following notices.
 * License: GPLv3. http://geekscape.org/static/arduino_license.html
 * ----------------------------------------------------------------------------
 *
 * To Do
 * ~~~~~
 * - Change filename from "testit00.csv" to "rocket00.csv".
 * - Replace sendMessage() with a combined storage / transmit method.
 */

Sd2Card  card;
SdVolume volume;
SdFile   root;
SdFile   file;

const char *infoMessageCardDetect = "i:MicroSD card detected";

const char *errorMessageCardDetect = "e:MicroSD card missing";
const char *errorMessageCardInit   = "e:MicroSD card initialization failed";
const char *errorMessageVolumeInit = "e:MicroSD volume initialization failed";
const char *errorMessageOpenRoot   = "e:MicroSD open root directory failed";
const char *errorMessageOpenFile   = "e:MicroSD open telemetry file failed";

void storageInitialize() {
  if (digitalRead(PIN_SD_CARD_DETECT)) {
    errorMessage = errorMessageCardDetect;
    return;
  }

  sendMessage(infoMessageCardDetect);

  if (card.init(SPI_HALF_SPEED, PIN_SD_CARD_SELECT) == false) {
    errorMessage = errorMessageCardInit;
    return;
  }

  if (volume.init(card) == false) {
    errorMessage = errorMessageVolumeInit;
    return;
  }

  if (root.openRoot(volume) == false) {
    errorMessage = errorMessageCardDetect;
    return;
  }

  // New incremented filename every time you boot

  char filename[] = "testit00.csv";

  for (uint8_t index = 0; index < 100; index ++) {
    filename[6] = index / 10 + '0';
    filename[7] = index % 10 + '0';
    if (file.open(root, filename, O_CREAT | O_EXCL | O_WRITE)) break;
  }

  if (file.isOpen() == false) {
    errorMessage = errorMessageOpenFile;
    return;
  }

  globalString.begin();
  globalString  = "i:Telemetry file: ";
  globalString  = filename;
  sendMessage(globalString);

  file.writeError = 0;

  storageInitialized = true;
}

void storageHandler() {
}

/*
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
