
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// TypeCon Type Deflector
// by Nicholas Felton
// Reflection-based drawing app developed for TypeCon 2015 Identity System
// Requires Control P5 Library: http://www.sojamo.de/libraries/controlP5/
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

// FEATURES
// Click anywhere to add a new line to drawing.
// Click and hold to change the start position of the last line.
// Subsequent single clicks create new lines.
// Line length and reflection style can be adjusted using the on-screen controls.
// Edit 'typeString' to change text.
// Edit 'typeFace' and 'typeSize' to change the typeface parameters.
// Press 's' key to save drawing as a pdf

// - - - - - - - - - - - - - - - - - - - - - - - 
// LIBRARIES
// - - - - - - - - - - - - - - - - - - - - - - - 
import java.util.Calendar;
import processing.pdf.*;
import controlP5.*;

// - - - - - - - - - - - - - - - - - - - - - - - 
// GLOBAL VARIABLES
// - - - - - - - - - - - - - - - - - - - - - - - 

// Type
PFont myFont;
String typeface = "Helvetica-Bold";
String typeString = "CONDENSED";
int typeSize = 260;
color c_textFill = color(50);

// PGraphics
PGraphics pg;

// Deflector
Deflector myDeflector[];
int startMarkerSize = 20;
int drawCycles = 1000;
boolean record;
int deflectionFactor = -2;
int deflectionSetting = 1;

// Control P5
ControlP5 cp5;
Slider s1;
RadioButton r;

// - - - - - - - - - - - - - - - - - - - - - - - 
// SETUP
// - - - - - - - - - - - - - - - - - - - - - - - 
void setup() {
  size(1800, 600);
  smooth();
  cp5 = new ControlP5(this);
  initializeSlider();
  initializeSelector();
  myFont = createFont(typeface, 50);
  myDeflector = new Deflector[0];
  drawOffScreenText(); // draw buffer once in setup to add initial point
  randomPoint();
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW
// - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
  if (record) {
    beginRecord(PDF, timestamp() + "_##.pdf");
  }
  background(0);
  drawOffScreenText();
  drawScreenText();
  for (int i=0; i<myDeflector.length; i++) {
    myDeflector[i].display();
  }
  if (record) {
    endRecord();
    record = false;
  }
}

