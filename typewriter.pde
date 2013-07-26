Round round;

PFont f;
String words;

boolean isMoving; 
float posX;
float lastX;
float charwidth;
float speed;

void setup()
{
  // Setup draw area.
  size(600, 360);
  smooth();
  frameRate(60);

  f = createFont("Courier", 32, true);

  // posX is horizontal position of the text;
  posX = width/2;

  // posX is the approximate width of each letter. Thus, the distance to move.
  charwidth = 14;
  speed = 2.2;
  lastX = posX;
  isMoving = false;

  words = "";

  round = new Round(100, 100);
}

void draw()
{
  background(255); // Clears background.
  round.display();

  drawText();
}

void keyPressed() {
  if (isMoving)
  {
    // Accept no input;
    // Play stuck sound.
  }
  else
  {
    isMoving = true;
    
    // If DELETE is pressed.
    if (keyCode==8)
    {
      println("Deleting... Length:" + words.length());

      if (words.length() > 0)
      {
        // Remove last letter.
        words = words.substring(0, words.length() - 1);
      }
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
// Copyright/music title displa // Clears background.y


void drawText() {
  if (isMoving) {
    // Shift the words left.
    posX = posX - speed;
    if (lastX - posX >= charwidth) {
      isMoving = false;
      lastX = posX;
    }
  }
  pushMatrix();
  translate(posX, height/3);
  textFont(f);
  textAlign(LEFT);
  fill(0);
  textSize(24);
  text(words, 0, 0);
  line(0, 0, charwidth, 0);
  popMatrix();
}

