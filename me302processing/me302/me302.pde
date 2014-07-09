import processing.serial.*;     // import the Processing serial library
Serial myPort;                  // The serial port

float bgcolor = 0;          // Background color
float fgcolor = 255;          // Fill color
float xpos = 0;              //xposition is simple incremented value for plotting
float ypos = 0;              //
boolean firstContact = false;        // Whether we've heard from the microcontroller

int width = 640;
int height = 480;


void setup() {
  size(width, height);
  background(bgcolor);
  // List all the available serial ports
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino module, so I open Serial.list()[0].
  // Change the 0 to the appropriate number of the serial port
  // that your microcontroller is attached to.
  myPort = new Serial(this, Serial.list()[0], 9600);

  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
  
  // draw with smooth edges:
  smooth();
}

void draw() {
  
  stroke(fgcolor);
  // Draw the shape
  //ellipse(xpos, ypos, 5, 5);
  
  if (xpos >= width) {
    xpos = 0;
    background(#000000);
  }
  else {
    xpos++;
  }
}

// serialEvent  method is run automatically by the Processing applet
// whenever the buffer reaches the  byte value set in the bufferUntil() 
// method in the setup():

void serialEvent(Serial myPort) { 
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  if (myString != null){
    myString = trim(myString);
 
 
    if (firstContact == false) {
      if (myString.equals("hello")){
        myPort.clear();
        firstContact = true;
        myPort.write('A');
      }
    }
    else {
    // split the string at the commas
    // and convert the sections into integers:
    int sensors[] = int(split(myString, ','));

    // print out the values you got:
    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t"); 
    }
    // add a linefeed after all the sensor values are printed:
    println();
    delay(100);
    if (sensors.length > 1) {
      //xpos = map(sensors[0], 0,1023,0,width);
      ypos = map(sensors[1], 0,1023,0,height);
      fgcolor = sensors[2];
    }
    // send a byte to ask for more data:
    myPort.write("A");
  }
  }
}
