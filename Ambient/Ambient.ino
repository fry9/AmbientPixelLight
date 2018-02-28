/*-----------------------------------------
 "Ambient.ino"
 This is the controller program for WS2812B or NeoPixel.
 It talks with the client over serial.
-----------------------------------------*/


#include "FastLED.h"

#define NUM_LEDS 15
#define DATA_PIN 3
#define BRIGHTNESS 220

CRGB leds[NUM_LEDS];

int red, green, blue;

int hueIncreass = 0;

void setup() {
  Serial.begin(9600);

  FastLED.addLeds<WS2812B, DATA_PIN, RGB>(leds, NUM_LEDS);
  FastLED.setBrightness( BRIGHTNESS );

  for (int i = 0; i < 16; i = i + 1) {
    leds[i] = CRGB(44, 189, 33);
    FastLED.show();
    delay(20);
  }
  delay(500);

  FastLED.clear();
  FastLED.show();

}

void loop() {

  if (Serial.available() >= 4) {
    if (Serial.read() == 0xff) {
      
      red = Serial.read();
      green = Serial.read();
      blue = Serial.read();

    

      /*
      if ((red > green) && (red > blue)) {
        green = green - hueIncreass;
        blue = blue - hueIncreass;
      } else if ((green > red) && (green > blue)) {
        red = red - hueIncreass;
        blue = blue - hueIncreass;
      } else {
        red = red - hueIncreass;
        green = green - hueIncreass;
      }
      */

      if (red < 0) red = 0;
      if (green < 0) green = 0;
      if (blue < 0) blue = 0;

      if (red > 255) red = 255;
      if (green > 255) green = 255;
      if (blue > 255) blue = 255;


      //leds[0] = CRGB( green, red, blue);
      fill_solid(leds, NUM_LEDS, CRGB( green, red, blue) );
      FastLED.show();
    }
  }

}
