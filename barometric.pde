/* barometric.pde
 * ~~~~~~~~~~~
 * Please do not remove the following notices.
 * License: GPLv3. http://geekscape.org/static/arduino_license.html
 * ----------------------------------------------------------------------------
 *
 * To Do
 * ~~~~~
 * - Determine barometric sensor sample time.
 * - Provide a barometric calibration mechanism ... using EEPROM ?
 * - Transform barometric pressure into altitude.
 */

#define BMP085_I2C_ADDRESS 0x77

const unsigned char oversampling_setting = 3;
const unsigned char pressure_waittime[4] = { 5, 8, 14, 26 };

  int ac1;
  int ac2;
  int ac3;
  unsigned int ac4;
  unsigned int ac5;
  unsigned int ac6;
  int b1;
  int b2;
  int mb;
  int mc;
  int md;

void barometricInitialize() {
  Wire.begin();
 
  bmp085_get_cal_data();
}

void bmp085_get_cal_data() {
  ac1 = read_int_register(0xAA);
  ac2 = read_int_register(0xAC);
  ac3 = read_int_register(0xAE);
  ac4 = read_int_register(0xB0);
  ac5 = read_int_register(0xB2);
  ac6 = read_int_register(0xB4);
  b1  = read_int_register(0xB6);
  b2  = read_int_register(0xB8);
  mb  = read_int_register(0xBA);
  mc  = read_int_register(0xBC);
  md  = read_int_register(0xBE);
}

void barometricHandler() {
  int temperature = 0;
  long pressure = 0;

  int ut = bmp085_read_ut();
  long up = bmp085_read_up();
  long x1, x2, x3, b3, b5, b6, p;
  unsigned long b4, b7;

  //calculate the temperature
  x1 = ((long) ut - ac6) * ac5 >> 15;
  x2 = ((long) mc << 11) / (x1 + md);
  b5 = x1 + x2;
  temperature = (b5 + 8) >> 4;

  //calculate the pressure
  b6 = b5 - 4000;
  x1 = (b2 * (b6 * b6 >> 12)) >> 11;
  x2 = ac2 * b6 >> 11;
  x3 = x1 + x2;

  if (oversampling_setting == 3) b3 = ((int32_t) ac1 * 4 + x3 + 2) << 1;
  if (oversampling_setting == 2) b3 = ((int32_t) ac1 * 4 + x3 + 2);
  if (oversampling_setting == 1) b3 = ((int32_t) ac1 * 4 + x3 + 2) >> 1;
  if (oversampling_setting == 0) b3 = ((int32_t) ac1 * 4 + x3 + 2) >> 2;

  x1 = ac3 * b6 >> 13;
  x2 = (b1 * (b6 * b6 >> 12)) >> 16;
  x3 = ((x1 + x2) + 2) >> 2;
  b4 = (ac4 * (uint32_t) (x3 + 32768)) >> 15;
  b7 = ((uint32_t) up - b3) * (50000 >> oversampling_setting);
  p = b7 < 0x80000000 ? (b7 * 2) / b4 : (b7 / b4) * 2;

  x1 = (p >> 8) * (p >> 8);
  x1 = (x1 * 3038) >> 16;
  x2 = (-7357 * p) >> 16;
  pressure = p + ((x1 + x2 + 3791) >> 4);
  
  globalString.begin();
  globalString  = "p:";
  globalString += pressure;
  globalString += ",";
  globalString += (((temperature - (temperature % 10)) / 10));
  globalString += (".");
  globalString += (temperature % 10);
  
  sendMessage(globalString);
}

unsigned int bmp085_read_ut() {
  write_register(0xf4, 0x2e);
  delay(5);
  return read_int_register(0xf6);
}

long bmp085_read_up() {
  write_register(0xf4, 0x34 + (oversampling_setting << 6));
  delay(pressure_waittime[oversampling_setting]);
  unsigned char msb, lsb, xlsb;
  
  Wire.beginTransmission(BMP085_I2C_ADDRESS);
  Wire.send(0xf6);
  Wire.endTransmission();

  Wire.requestFrom(BMP085_I2C_ADDRESS, 3);
  while(! Wire.available());
  msb = Wire.receive();
  while(! Wire.available());
  lsb |= Wire.receive();
  while(! Wire.available());
  xlsb |= Wire.receive();

  return (((long) msb << 16) | ((long) lsb << 8) | ((long) xlsb)) >> (8 - oversampling_setting);
}

void write_register(
  unsigned char r,
  unsigned char v) {

  Wire.beginTransmission(BMP085_I2C_ADDRESS);
  Wire.send(r);
  Wire.send(v);
  Wire.endTransmission();
}

char read_register(
  unsigned char r) {

  unsigned char v;
  Wire.beginTransmission(BMP085_I2C_ADDRESS);
  Wire.send(r); // register to read
  Wire.endTransmission();

  Wire.requestFrom(BMP085_I2C_ADDRESS, 1); // read a byte
  while(! Wire.available());
  v = Wire.receive();
  return v;
}

int read_int_register(
  unsigned char r) {

  unsigned char msb, lsb;
  Wire.beginTransmission(BMP085_I2C_ADDRESS);
  Wire.send(r); // register to read
  Wire.endTransmission();

  Wire.requestFrom(BMP085_I2C_ADDRESS, 2); // read a byte
  while(! Wire.available());
  msb = Wire.receive();
  while(! Wire.available());
  lsb = Wire.receive();
  return (((int) msb << 8) | ((int) lsb));
}
