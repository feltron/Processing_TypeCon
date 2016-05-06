
// - - - - - - - - - - - - - - - - - - - - - - - 
// FUNCTIONS
// - - - - - - - - - - - - - - - - - - - - - - - 

void drawOffScreenText() {
  pg = createGraphics(width, height, JAVA2D);
  pg.beginDraw();
  pg.background(0);
  pg.textAlign(CENTER, CENTER);
  pg.fill(c_textFill);
  pg.textFont(myFont, typeSize);
  pg.text(typeString, pg.width/2, pg.height/2); 
  pg.endDraw();
}

// - - - - - - - - - - - - - - - - - - - - - - - 

void drawScreenText() {
  fill(c_textFill);
  noStroke();
  textFont(myFont, typeSize);
  textAlign(CENTER, CENTER);
  text(typeString, width/2, height/2);
}

// - - - - - - - - - - - - - - - - - - - - - - - 

void mouseClicked() {
  PVector mouseClick = new PVector(mouseX, mouseY);
  if (mouseY < height-100 && mouseY > 100) {
    PVector mousePosition = new PVector(mouseX, mouseY);
    myDeflector=(Deflector[])append(myDeflector, new Deflector(mousePosition, deflectionSetting));
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 

void mouseDragged() {
  PVector mouseClick = new PVector(mouseX, mouseY);
  if (mouseY < height-60) {
    myDeflector[myDeflector.length-1].initializeDeflector(mouseClick, deflectionSetting);
  }
}


// - - - - - - - - - - - - - - - - - - - - - - - 

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

// - - - - - - - - - - - - - - - - - - - - - - - 

void keyPressed() {
  if (key == 's') {
    record = true;
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 

void randomPoint() {
  PVector randomLocation = new PVector(random(200, width-200), random(height/2-200, height/2+200));
  myDeflector=(Deflector[])append(myDeflector, new Deflector(randomLocation, deflectionSetting));
}

// - - - - - - - - - - - - - - - - - - - - - - - 

void initializeSlider() {
  cp5.addSlider("s1")
    .setPosition(20, height-30)
      .setSize(400, 8)
        .setRange(200, 5000)
          .setValue(drawCycles)
            .setColorForeground(color(255, 128))
              .setColorBackground(color(60))
                .setColorActive(color(255, 128));
}


// - - - - - - - - - - - - - - - - - - - - - - - 

void s1(int sliderValue) {
  if (cp5.controller("s1").isMousePressed()) {
    drawCycles = sliderValue;
    PVector startPosition = new PVector(myDeflector[myDeflector.length-1].dPath_x[0], myDeflector[myDeflector.length-1].dPath_y[0]);
    myDeflector[myDeflector.length-1].initializeDeflector(startPosition, deflectionSetting);
  }
}
// - - - - - - - - - - - - - - - - - - - - - - - 

void initializeSelector() {
  r = cp5.addRadioButton("r1")
    .setPosition(20, 20)
      .setSize(10, 10)
        .setColorForeground(color(255, 128))
          .setColorBackground(color(60))
            .setColorActive(color(255, 200))
              .setColorLabel(color(255))
                .setItemsPerRow(5)
                  .setSpacingColumn(50)
                    .addItem("Bounce", 1)
                      .addItem("Squiggle", 2)
                        .activate(0);
}

// - - - - - - - - - - - - - - - - - - - - - - - 

void r1(int a) {
  deflectionSetting = a;
  PVector startPosition = new PVector(myDeflector[myDeflector.length-1].dPath_x[0], myDeflector[myDeflector.length-1].dPath_y[0]);
  myDeflector[myDeflector.length-1].initializeDeflector(startPosition, deflectionSetting);
}

// - - - - - - - - - - - - - - - - - - - - - - - 

int hexToGrey(int pVal) {
  int r=(pVal&0x00FF0000)>>16;
  int g=(pVal&0x0000FF00)>>8;
  int b=(pVal&0x000000FF);
  int grey=(r+b+g)/3;
  return grey;
}

