/* storage.pde
 * ~~~~~~~~~~~
 * Please do not remove the following notices.
 * License: GPLv3. http://geekscape.org/static/arduino_license.html
 * ----------------------------------------------------------------------------
 *
 * To Do
 * ~~~~~
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
const char *errorMessageSyncFile   = "e:MicroSD sync telemetry file failed";

byte storageInitialized = false;

void storageInitialize() {
  if (digitalRead(PIN_SD_CARD_DETECT)) {
    errorMessage = errorMessageCardDetect;
    return;
  }

  sendMessage(infoMessageCardDetect, LOG_SERIAL, LOG_STORAGE);

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

  char filename[] = "rocket00.csv";

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
  globalString += filename;
  sendMessage(globalString, LOG_SERIAL, LOG_STORAGE);

  file.writeError = 0;

  storageInitialized = true;
}

void storageLog(
  const char* message) {

  if (storageInitialized) file.println(message);
}

void storageFlushHandler() {
  if (storageInitialized) {
    if (file.sync() == false) {
      errorMessage = errorMessageSyncFile;

      storageInitialized = false;
    }
  }
}

void storageTimeHandler() {
  if (storageInitialized) file.println(millisecondCounterAsString());
}
