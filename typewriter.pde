Round round;
PFont f;
String words;
boolean isMoving; 
int x;
int lastx;

void setup()
{
  size(600, 360);
  f = createFont("Courier", 32, true);
  smooth();
  frameRate(60);
  isMoving = false;
  x = width/2;
  lastx = x;
  words = "";
  round = new Round(100, 100);
}

void draw()
{
  background(255);
  round.display();
  displayInfo();
}

void keyPressed() {
  if (isMoving)
  {
    // Accept no input;
  }
  else
  {
    isMoving = true;
    if (keyCode==8)
    {
      println("Deleting... Length:" + words.length());
      if (words.length() > 0)
        words = words.substring(0, words.length() - 1);
    }
    else
    {
      // Do not concat if delete was pressed.
      words = words + String.valueOf(key);
    }

    // Console out.
    //println("key: " + String.valueOf(key) + " value: " + int(key) + " code: " + keyCode);
  }
}

// Add typing sounds
// Add paper grain
// Add varying strenght of ink
// Add move back for delete
// Add next line animation
// Dual motion animation (cos?)
// Speed is function of font size
// Vignetting

// And ending
// Background music (Pura suadade)

// Copyright/music title display

void displayInfo() {
  if (isMoving) {
    x = x - 3;
    if(lastx - x >= 14) {
      isMoving = false;
      lastx = x;
    }
  }
  pushMatrix();
  translate(x, height/3);
  textFont(f);
  textAlign(LEFT);
  fill(0);
  textSize(24);
  text(words, 0, 0);
  popMatrix();
}

