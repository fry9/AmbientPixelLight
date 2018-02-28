/*-----------------------------------------
 "AmbientC.pde"
 The client for ambient. Written in Processing.
 It sends rgb values to the arduino pixels based on what is displayed on screen.
-----------------------------------------*/

import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.InputEvent;
import java.awt.image.BufferedImage;
import java.awt.Rectangle;
import java.awt.Dimension;
import processing.serial.*;
 
 
Serial port;
Robot robby;
 
void setup()
{
  println(Serial.list());
port = new Serial(this, Serial.list()[1],9600);
size(100, 100); //doesn't matter
try
{
robby = new Robot();
}
catch (AWTException e)
{
println("Robot class not supported by your system!");
exit();
}
}
 
void draw()
{
int pixel;

float r=0;
float g=0;
float b=0;
 
int skipValue = 8;
int x = 1920;
int y = 1080;
 

BufferedImage screenshot = robby.createScreenCapture(new Rectangle(new Dimension(x,y)));
 
 
int i=0;
int j=0;
//Skip every alternate pixel making my program 4 times faster
for(i =0;i<x; i=i+skipValue){
for(j=0; j<y;j=j+skipValue){
pixel = screenshot.getRGB(i,j);
r = r+(int)(255&(pixel>>16)); //add up reds
g = g+(int)(255&(pixel>>8)); //add up greens
b = b+(int)(255&(pixel)); //add up blues
}
}
int aX = x/skipValue;
int aY = y/skipValue;
r=r/(aX*aY); //average red
g=g/(aX*aY); //average green
b=b/(aX*aY); //average blue

 
float maxColorInt;
float minColorInt;
 
maxColorInt = max(r,g,b);
if(maxColorInt == r){
  // red
  if(maxColorInt < (225-20)){
    r = maxColorInt + 20;  
  }
}
else if (maxColorInt == g){
  //green
  if(maxColorInt < (225-20)){
    g = maxColorInt + 20;  
  }
}
else {
   //blue
   if(maxColorInt < (225-20)){
    b = maxColorInt + 20;  
  }  
}
 
minColorInt = min(r,g,b);
if(minColorInt == r){
  // red
  if(minColorInt > 20){
    r = minColorInt - 20;  
  }
}
else if (minColorInt == g){
  //green
  if(minColorInt > 20){
    g = minColorInt - 20;  
  }
}
else {
   //blue
   if(minColorInt > 20){
    b = minColorInt - 20;  
  }  
}
 
 
port.write(0xff);
port.write((byte)(r)); //write red value
port.write((byte)(g)); //write green value
port.write((byte)(b)); //write blue value

delay(10);
}