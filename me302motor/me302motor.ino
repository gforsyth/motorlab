#include <Encoder.h>
#include <DualMC33926MotorShield.h>

Encoder motor(2,3);
DualMC33926MotorShield md;

int amp = 0;
unsigned long oldtime = 0;
unsigned long newtime = 0;
int oldphi = 0;
int newphi = 0;
int inByte = 0;


void setup() 
{
  //initialize serial communications at a 9600 baud rate
  Serial.begin(9600);
  md.init();
  establishContact();
}

void loop()
{
  if (Serial.available() > 0) {  
    oldtime = newtime;
    oldphi = newphi;
    inByte = Serial.read();
    
    //students can write code from here until end of loop()
    md.setM2Speed(50);
    newtime = millis();
    newphi = motor.read();
    amp = md.getM2CurrentMilliamps();
    
    Serial.print(oldphi);
    Serial.print(",");
    Serial.print(newphi);
    Serial.print(",");
    Serial.print(oldtime);
    Serial.print(",");
    Serial.print(newtime);
    Serial.print(",");
    Serial.print(amp);
    Serial.println();
   
     
    //students should stop here
   
   }
}

void establishContact() {
 while (Serial.available() <= 0) {
      Serial.println("hello");   // send a starting message
      delay(300);
   }
 }

