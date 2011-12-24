#include <string.h>
#include <stdio.h>
#include <Wire.h> // This seems redundant, but we need to declare this
                  // dependency in the pde file or else it won't be included
                  // in the build.
#include "nunchuk.h"

/*int outPin = 3;
int outputDelay = 10;

void setup()
{
  pinMode(outPin, OUTPUT);
  pinMode(13, OUTPUT);
}

void sendBit(int data)
{
  digitalWrite(outPin, data);
  //digitalWrite(13, data);
  delay(outputDelay);
}

void sendData(int velocity, int angle, int servo)
{
  // send first bit
  sendBit(HIGH);
  
  // send five zeros
  sendBit(LOW);
  sendBit(LOW);
  sendBit(LOW);
  sendBit(LOW);
  sendBit(LOW);
  
  // send a space, 1
  sendBit(HIGH);
  
  // now send the velocity (positive/negative sign, then 3 bit magnitude)
  if (velocity < 0)
  {
    sendBit(LOW);
  }
  else
  {
    sendBit(HIGH);
  }
  velocity = abs(velocity);
  sendBit(HIGH && (velocity & B000100));
  sendBit(HIGH && (velocity & B000010));
  sendBit(HIGH && (velocity & B000001));  
  
  // send a space, 1
  sendBit(HIGH);
  
  // now send the angle (positive/negative sign, then 3 bit magnitude)
  if (angle < 0)
  {
    sendBit(LOW);
  }
  else
  {
    sendBit(HIGH);
  }
  angle = abs(angle);
  sendBit(HIGH && (angle & B000100));
  sendBit(HIGH && (angle & B000010));
  sendBit(HIGH && (angle & B000001));
  
  // send a space, 1
  sendBit(HIGH);
  
  // now send the servo command (positive/negative)
  sendBit(servo);
  
  // send a space, 1
  sendBit(HIGH);
  
  // send the checksum (not yet implemented)
  //sendBit(HIGH);
  //sendBit(HIGH);
}

int time = 3000;
boolean loopodd = true;
void loop()
{
  
  sendData(3, 5, 0);
  
  sendBit(LOW);
  
  if (loopodd)
  {
    digitalWrite(13, HIGH);
  }
  else
  {
    digitalWrite(13, LOW);
  }
  loopodd = !loopodd;
}*/



//dirt cheap wireless TX
//generates 38kHz carrier wave on pin 9 and 10
//sends data via TX every 500ms
void setup()
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

  Serial.begin(2400);
  
  nunchuk_init();
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
