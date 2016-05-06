
// - - - - - - - - - - - - - - - - - - - - - - - 
// DEFLECTOR CLASS
// - - - - - - - - - - - - - - - - - - - - - - - 

class Deflector { 
  PVector p_location, p_locationPrev, p_velocity, sumAngles;
  PVector[] pixelVector = new PVector[9];
  float[] dPath_x;
  float[] dPath_y;
  boolean flipper = false;
  int deflectionType;

  Deflector(PVector mousePosition, int deflectionType_) {
    deflectionType = deflectionType_;
    initializeDeflector(mousePosition, deflectionType);
  }

  // - - - - - - - - - - - - - - - - - - - - - - - 

  void display() {
    // Draw Rays
    beginShape();
    for (int i=1; i<dPath_x.length-1; i++) {
      noFill();
      strokeWeight(2);
      stroke(150);
      curveVertex(dPath_x[i-1], dPath_y[i-1]);
    }
    endShape();
  }

  // - - - - - - - - - - - - - - - - - - - - - - - 

  void initializeDeflector(PVector mousePosition, int deflectionSelection) {
    p_location = new PVector(mousePosition.x, mousePosition.y);
    p_locationPrev = new PVector(mousePosition.x, mousePosition.y);
    dPath_x = new float[1];
    dPath_y = new float[1];
    dPath_x[0] = mousePosition.x;
    dPath_y[0] = mousePosition.y;
    deflectionType = deflectionSelection;
    computeRays();
  }

  // - - - - - - - - - - - - - - - - - - - - - - - 

  void computeRays() {
    p_velocity = new PVector(1, 1);
    p_velocity.normalize();
    for (int i=0; i<drawCycles; i++) {
      p_velocity = computeDeflection(p_velocity);
      p_location.add(p_velocity);
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - 

  PVector computeDeflection(PVector v_inbound) {
    for (int i = 0; i < pixelVector.length; i++) {
      pixelVector[i] = new PVector();
    }
    for (int i=-1; i<2; i++) {
      for (int j=-1; j<2; j++) {
        int iteration = (i+1)*3+j+1;
        pixelVector[iteration].set(i, j);
        pixelVector[iteration].normalize();
        color pixelValue = pg.get(int(p_location.x+i+v_inbound.x), int(p_location.y+j+v_inbound.y));
        int vectorFactor = hexToGrey(pixelValue);
        pixelVector[iteration].mult(vectorFactor);
      }
    }
    // Average Vectors
    sumAngles = new PVector(0, 0);
    for (int i = 0; i < pixelVector.length; i++) {
      sumAngles.add(pixelVector[i]);
    }
    // Calculate Outbound Angle
    PVector v_outbound = new PVector(0, 0);
    sumAngles.rotate(PI/2);
    v_outbound = v_inbound.get();
    if (sumAngles.x != 0.0 && sumAngles.y != 0.0) { // If both, then not an edge
      noFill();
      stroke(255, 0, 0);
      // Show tangent lines
      // line(p_location.x-sumAngles.x, p_location.y-sumAngles.y, p_location.x+sumAngles.x, p_location.y+sumAngles.y);
      float deltaAngle = v_inbound.heading() - sumAngles.heading();
      if (deflectionType == 1) {
        // bounce deflection
        v_outbound.rotate(deflectionFactor*deltaAngle);
      } else if (deflectionType == 2) {
        // squiggle deflection
        if (flipper) {
          v_outbound.rotate(1.05*PI);
        } else {
          v_outbound.rotate(-1.05*PI);
        }
        flipper = !flipper;
      }
      dPath_x = append(dPath_x, p_location.x);
      dPath_y = append(dPath_y, p_location.y);
    }
    return v_outbound;
  }
}

