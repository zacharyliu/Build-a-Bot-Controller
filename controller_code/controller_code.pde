#include <string.h>
#include <stdio.h>
#include <Wire.h>
#include "nunchuk.h"

//dirt cheap wireless TX
//generates 38kHz carrier wave on pin 9 and 10
//sends data via TX every 500ms
void setup()
{
  wireless_setup();
  
  Serial.begin(2400);
  
  nunchuk_init();
}

void wireless_setup()
{
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);

  // Clear Timer on Compare Match (CTC) Mode
  bitWrite(TCCR1A, WGM10, 0);
  bitWrite(TCCR1A, WGM11, 0);
  bitWrite(TCCR1B, WGM12, 1);
  bitWrite(TCCR1B, WGM13, 0);

  // Toggle OC1A and OC1B on Compare Match.
  bitWrite(TCCR1A, COM1A0, 1);
  bitWrite(TCCR1A, COM1A1, 0);
  bitWrite(TCCR1A, COM1B0, 1);
  bitWrite(TCCR1A, COM1B1, 0);

  // No prescaling
  bitWrite(TCCR1B, CS10, 1);
  bitWrite(TCCR1B, CS11, 0);
  bitWrite(TCCR1B, CS12, 0);

  OCR1A = 210;
  OCR1B = 210;
}

int velocity;
int angle;
int servo;

boolean get_data_from_nunchuck()
{
  int jx, jy, ax, ay, az, bz, bc;
  if(nunchuk_read(&jx, &jy, &ax, &ay, &az, &bz, &bc))
  {
    if (jy > 8 || jy < -8) {
      velocity = jy;
    } else {
      velocity = 0;
    }
    
    if (jx > 8 || jx < -8) {
      angle = jx;
    } else {
      angle = 0;
    }
    
    if (bc == 1) {
      servo = 1;
    } else if (bz == 1) {
      servo = -1;
    } else {
      servo = 0;
    }
    
    return true;
  } else {
    return false;
  }
}

void loop()
{
  if (get_data_from_nunchuck()) {
    Serial.print("^");
    Serial.print(velocity);
    Serial.print("|");
    Serial.print(angle);
    Serial.print("|");
    Serial.print(servo);
    Serial.print("$");
  }
  delay(100);
}
