int outPin = 3;
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
}
