import processing.serial.*;     // import the Processing serial library
import java.io.FileWriter;      // java library for logging data
Serial myPort;                  // The serial port

float bgcolor = 0;          // Background color
float fgcolor = 255;          // Fill color
float xpos = 0;              //xposition is simple incremented value for plotting
float xposold = 0;              //xposition is simple incremented value for plotting
float ypos = 0;              //yposition received from arduino
float yposold = 0;              //previous position for drawing "new" part of line

boolean firstContact = false;        // Whether we've heard from the microcontroller
boolean dumpToFile = false;      //if true then data is logged to file

//dimensions of plotting window
int width = 640;
int height = 480;


void setup() {
  size(width, height);    //create window width x height
  background(bgcolor);    //set window all black
  // List all the available serial ports
  //println(Serial.list()); //print available serial ports (probably unnecessary)  

   myPort = new Serial(this, Serial.list()[0], 9600); //start serial connection to first port
   //might have to change this depending on computer

  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
  
  // draw with smooth edges:
  smooth();
}

void draw() {
  
  stroke(fgcolor);
  line(xpos,yposold,xpos+1,ypos); //draw line (x1, y1, x2, y2)
  
  //if x reaches the end of the window, clear it and start back at the beginning
  if (xpos >= width) {
    xpos = 0;
    xposold = 0;
    yposold = ypos;
    background(#000000);
  }
  else { //otherwise, increment x and y values
    xpos++;
    yposold = ypos;
  }
}

// serialEvent  method is run automatically by the Processing applet
// whenever the buffer reaches the  byte value set in the bufferUntil() 
// method in the setup():

void serialEvent(Serial myPort) { 
  // read the serial buffer until it hits a newline:
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  if (myString != null){
    myString = trim(myString);
 
 //arduino code spits out the word "hello" constantly until it is connects to processing
 //this statement checks to see if a connection has been established, if not it flushes
 //all the hellos out of the buffer and then asks for the first true data point
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
    
    //get yaxis value from sensors array -- can add multiple lines here if needed
    if (sensors.length > 1) {
      ypos = map((abs(sensors[1])-abs(sensors[0]))/(sensors[3]-sensors[2]), 0,1023,0,height);
      fgcolor = 255;
      print(ypos);
      println();
    }
    //write data to file if boolean dumpToFile is true
    if (dumpToFile){
      String tempStr;
      tempStr = millis() + "," + sensors[0] +","+ sensors[1] +","+ sensors[2] + "\r\n";
      FileWriter file;
      
      try
      {
        file = new FileWriter("/home/gil/me302gtf/data.txt", true);
        file.write(tempStr, 0, tempStr.length());
        file.close();
      }
      catch(Exception e)
      {
         println("Error: Can't open file!"); 
      }
    }
    
    // wait a small bit then send a byte to ask for more data:
    delay(500);
    myPort.write("A");
  }
  }
}
