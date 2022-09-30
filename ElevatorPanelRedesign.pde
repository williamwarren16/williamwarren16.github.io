import controlP5.*;
ControlP5 cp5;

int currentF = 0;
boolean ON_OF = false;
color BL = #97a4b0;
color FL = #658099 ;
boolean helpCalled;
color helpBL = #b30000;
color helpFL = #ff0000;
boolean[] floorTarget = new boolean[4]; // 4 Floor to visit;
int elevator_direction = -1; // (-1 for up) (+1 for down)
int elevator_speed = 2;
int[] floor_y = {900, 750, 600, 450};
boolean isMoving = false;
float elevatorX=80, elevatorY=floor_y[currentF];
controlP5.Button closeD;
controlP5.Button openD;
controlP5.Button one;
controlP5.Button two;
controlP5.Button three;
controlP5.Button four;
controlP5.Button help;
int last_stop;


void setup() {
  size(650, 1250);
  cp5 = new ControlP5(this);
  PFont font = createFont("arial", 35);
  closeD = cp5.addButton("closeD").setValue(6).setPosition(80, 1050).setSize(140, 140).setCaptionLabel("CLOSE\nDoor").setColorForeground(FL).setColorBackground(BL).setFont(font);
  openD = cp5.addButton("openD").setValue(5).setPosition(430, 1050).setSize(140, 140).setCaptionLabel("open\nDoor").setColorForeground(FL).setColorBackground(BL).setFont(font);
  one = cp5.addButton("visit_floor_one").setValue(1).setPosition(255, floor_y[0]).setSize(140, 140).setCaptionLabel("1").setColorForeground(FL).setColorBackground(BL).setFont(font);
  two = cp5.addButton("visit_floor_two").setValue(2).setPosition(255, floor_y[1]).setSize(140, 140).setCaptionLabel("2").setColorForeground(FL).setColorBackground(BL).setFont(font);
  three = cp5.addButton("visit_floor_three").setValue(3).setPosition(255, floor_y[2]).setSize(140, 140).setCaptionLabel("3").setColorForeground(FL).setColorBackground(BL).setFont(font);
  four = cp5.addButton("visit_floor_four").setValue(4).setPosition(255, floor_y[3]).setSize(140, 140).setCaptionLabel("4").setColorForeground(FL).setColorBackground(BL).setFont(font);

  help = cp5.addButton("help").setValue(7).setPosition(430, 50).setSize(140, 140).setCaptionLabel("HELP").setColorForeground(helpFL).setColorBackground(helpBL).setFont(font);

  for (int i=0; i<4; i++) {
    floorTarget[i] = false;
  }

  helpCalled = false;
  ON_OF =  false;
  last_stop = millis();
}


void draw() {
  background(45, 50, 65);
  strokeWeight(2);

  // Touch Screen
  fill(240, 240, 240);
  rect(50, 20, 550, 1200);

  //time
  float h, m, s;
  h = hour();
  m = minute();
  s = second();
  textSize(40);
  fill(50);
  String time_string = "Time: ";
  if (h<10) time_string+="0";
  time_string += int(h);
  time_string+=":";
  if (m<10) time_string+="0";
  time_string += int(m);
  time_string+=":";
  if (s<10) time_string+="0";
  time_string += int(s);
  text(time_string, 80, 140);

  //date
  int d = day();    // Values from 1 - 31
  int mon = month();  // Values from 1 - 12
  int y = year();
  textSize(40);
  fill(50);
  String date_string = "Date: ";
  if (mon<10) date_string+="0";
  date_string += int(mon);
  date_string+="/";

  if (d<10) date_string+="0";
  date_string += int(d);
  date_string+="/";
  date_string += int(y);
  text(date_string, 80, 90);

  if (!helpCalled) {
    // current floor level
    textSize(250);
    text(currentF+1, 260, 380);
    showElevator();
    closeD.show();
    openD.show();
    one.show();
    help.show();
    two.show();
    three.show();
    four.show();
  }else{
    closeD.hide();
    openD.hide();
    one.hide();
    help.hide();
    two.hide();
    three.hide();
    four.hide();
    textSize(90);
    text("Help Called", 110, 380);
    textSize(28);
    text("Press Any Key to start the elevator again", 100, 450);
  }
}

void keyPressed(){
  helpCalled = false;
}


void showElevator() {
  fill(55);
  rect(elevatorX, elevatorY, 140, 140);
  if(ON_OF){
    fill(0,255,255);
    rect(elevatorX+10, elevatorY+10, 120, 120);
  }
  moveElevator();
  for (int i=0; i<4; i++) {
    if (floorTarget[i]) {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(10);
      rect(255-5, floor_y[i]-5, 150, 150);
    }
  }
  stroke(0);
  strokeWeight(1);
}

void moveElevator() {
  if (isMoving) {
    ON_OF = false;
    if(millis()-last_stop>2000){
      elevatorY += elevator_direction*elevator_speed;
    }
    for (int i=0; i<4; i++) {
      if (floorTarget[i] && floor_y[i]==elevatorY) {
        floorTarget[i] = false;
        isMoving = false;
        last_stop = millis();
        currentF = i;
      }
    }
  }
  if (!isMoving) {
    if (elevator_direction==1) {
      for (int i=0; i<=currentF-1; i++) {
        if (floorTarget[i]) {
          isMoving = true;
          ON_OF = false;
          elevator_direction=1;
        }
      }
      if (!isMoving)
        elevator_direction*=-1;
    } else {
      for (int i=currentF+1; i<4; i++) {
        if (floorTarget[i]) {
          isMoving = true;
          ON_OF = false;
          elevator_direction=-1;
        }
      }
      if (!isMoving)
        elevator_direction*=-1;
    }
  }
}

public void visit_floor_one() {
  floorTarget[0] = true;
}

public void visit_floor_two() {
  floorTarget[1] = true;
}

public void visit_floor_three() {
  floorTarget[2] = true;
}

public void visit_floor_four() {
  floorTarget[3] = true;
}

public void openD() {
  ON_OF = true;
}

public void closeD() {
  ON_OF = false;
}

public void help() {
  helpCalled = !helpCalled;
}
