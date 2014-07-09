#include <Encoder.h>
#include <DualMC33926MotorShield.h>

Encoder motor(2,3);
DualMC33926MotorShield md;

unsigned long newtime = 0;
unsigned long oldtime = 0;
int newphi = 0;
int oldphi = -999;

void stopIfFault()
{
 if (md.getFault())
{
  Serial.println("fault");
  while(1);
} 
}

void setup()
{
  Serial.begin(9600);
  md.init();
}

void loop()
{
  md.setM2Speed(200);
  newtime = millis();
  newphi = motor.read();
//  Serial.print(oldtime);
//  Serial.print(" ");
//  Serial.print(newtime);
//  Serial.print(" ");
//  Serial.print(oldphi);
//  Serial.print(" ");
//  Serial.print(newphi);
//    Serial.print(" ");
//    Serial.print(md.getM2CurrentMilliamps());
//    Serial.println();
  if (newphi != oldphi)
  {
    oldphi = newphi;
    //int pos = newphi % 9;
    Serial.println(newphi);
//    Serial.print(abs(newphi-oldphi));
//    Serial.println();
//    oldtime = newtime;
//    oldphi = newphi;
    //delay(100);
  }
    
//    delay(500);    
}
