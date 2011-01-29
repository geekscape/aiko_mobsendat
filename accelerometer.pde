/* accelerometer.pde
 * ~~~~~~~~~~~~~~~~~
 * Please do not remove the following notices.
 * License: GPLv3. http://geekscape.org/static/arduino_license.html
 * ----------------------------------------------------------------------------
 *
 * To Do
 * ~~~~~
 * - Code clean-up.
 * - Seriously verify the accelerometer data !
 * - Check to see if we need to deselect the SPI bus between commands.
 * - Determine whether setup() delay loops can be optimized, i.e removed.
 * - Configure axis labels depending upon orientation ... using EEPROM.
 */

byte accelerometerBuffer[40][6];

byte accelerometerSamples;

byte adxlFIFO;  // ADXL FIFO status register

void accelerometerInitalize() {
  short readData;

  /* Setup the registers */

  Spi.mode((1 << SPE)  | (1 << MSTR) | (1 << CPOL) | (1 << CPHA) |
           (1 << SPR1) | (1 << SPR0));

  // Set select high, slave disabled waiting to pull low for first exchange
  digitalWrite(PIN_ACCEL_SELECT, HIGH);
  delay(4000);

  // Wait for POWER_CTL register to go to correct state
  readData = 0x00;

  while (readData != 0x28) {
    // POWER_CTL register: measure
    digitalWrite(PIN_ACCEL_SELECT, LOW);
    Spi.transfer(0x2D);
    Spi.transfer(0x28); // Measure

    digitalWrite(PIN_ACCEL_SELECT, HIGH);
    delay(5);

    digitalWrite(PIN_ACCEL_SELECT, LOW);

    // Set "read" MSB
    Spi.transfer(1 << 7 | 0x2D);

    // Send dummy byte to keep clock pulse going !
    readData = Spi.transfer(0x00);
    digitalWrite(PIN_ACCEL_SELECT, HIGH);
    delay(1000);
  }

  // Set format
  digitalWrite(PIN_ACCEL_SELECT, LOW);
  Spi.transfer(0x31);
  Spi.transfer(0x0B); //16G range
  digitalWrite(PIN_ACCEL_SELECT, HIGH);
  delay(5);

  //set rate
  digitalWrite(PIN_ACCEL_SELECT, LOW);
  Spi.transfer(0x2C);
  Spi.transfer(0x09);  //50Hz
  digitalWrite(PIN_ACCEL_SELECT, HIGH);
  delay(5);

  // Set FIFO
  digitalWrite(PIN_ACCEL_SELECT, LOW);
  Spi.transfer(0x38);  // FIFO CTL register
  Spi.transfer(0x81);  // 1000,0001 // stream mode and 1 sample watermark
  digitalWrite(PIN_ACCEL_SELECT, HIGH);
  delay(5);
}

void accelerometerHandler() {
  // All x,y,z data must be read from FIFO in a multiread burst
  adxlFIFO = 1;

  while (adxlFIFO != 0) {
    // This select/deselect must happen inside the loop.
    digitalWrite(PIN_ACCEL_SELECT, LOW);

    // Start reading at 0x32 and set "Read" and "Multi" bits
    Spi.transfer(1 << 7 | 1 << 6 | 0x32);

    for (int i = 0; i < 6; i ++) {
      // Sample the FIFO output
      accelerometerBuffer[accelerometerSamples][i] = Spi.transfer(0x00);
    }

    // Allow write to accelerometerbuffer entry 0.
    accelerometerSamples++;

    // Don't need the FIFO control register.
    Spi.transfer(0x00);

    // At least 5uS since read of xyz data
    adxlFIFO = (0x1F) & (Spi.transfer(0x00));
    digitalWrite(PIN_ACCEL_SELECT, HIGH);

    // Accelerometer FIFO reads zero when data has been placed on output,
    // this may be one sample late.
  }
}

void accelerometerDump() {
  float x, y, z;
  int i;

  for (i = 0; i < accelerometerSamples; i ++) {
    x = (float)
        ((accelerometerBuffer[i][1] << 8) | accelerometerBuffer[i][0]) / 250.0;

    y = (float)
        ((accelerometerBuffer[i][3] << 8) | accelerometerBuffer[i][2]) / 250.0;

    z = (float)
        ((accelerometerBuffer[i][5] << 8) | accelerometerBuffer[i][4]) / 250.0;

    serial.print("a: ");
    serial.print(x);
    serial.print(", ");
    serial.print(y);
    serial.print(", ");
    serial.println(z);
  }
}
