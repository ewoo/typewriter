Round round;

PFont f;
String words;

boolean isMoving;
boolean isForward;
float posX;
float lastX;
float charwidth;
float speed;

Maxim maxim;
AudioPlayer keySound;
AudioPlayer spaceSound;
AudioPlayer bellSound;
AudioPlayer returnSound;

void setup()
{
  // Setup draw area.
  size(600, 360);
  smooth();
  frameRate(60);

  // Init Maxim (audio keySound).
  maxim = new Maxim(this);

  keySound = maxim.loadFile("keystrike.wav");
  spaceSound = maxim.loadFile("spacebar.wav");
  bellSound = maxim.loadFile("bell.wav");
  returnSound = maxim.loadFile("carriagereturn.wav");
  keySound.setLooping(false);
  spaceSound.setLooping(false);
  bellSound.setLooping(false);
  returnSound.setLooping(false);

  f = createFont("Courier", 32, true);

  // posX is horizontal position of the text;
  posX = width/2;

  // posX is the approximate width of each letter. Thus, the distance to move.
  charwidth = 14;
  speed = 2.2;
  lastX = posX;
  isMoving = false;
  isForward = true;

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
      // Do not concat if delete was pressed.
      // Reverse animation.
      isForward = false;
      spaceSound.cue(0);
      spaceSound.play();

      if (words.length() > 0)
      {
        // Remove last letter.
        words = words.substring(0, words.length() - 1);
      }
    }
    else
    {
      if (key==' ')
      {
        spaceSound.cue(0);
        spaceSound.play();
      }
      else if (keyCode==10)
      {
        returnSound.cue(0);
        returnSound.play();
      }
      else
      {
        keySound.cue(0);
        keySound.play();
      }
      words = words + String.valueOf(key);
      if (words.length() == 20)
      {
        bellSound.cue(0);
        bellSound.play();
      }
    }

    // Console out.
    //println("key: " + String.valueOf(key) + " value: " + int(key) + " code: " + keyCode);
  }
}


void drawText() {
  if (isMoving) {
    if (isForward) {
      // Shift the words left.
      posX = posX - speed;
      if (lastX - posX >= charwidth) {
        isMoving = false;
        lastX = posX;
      }
    }
      else {
        // Shift the words left.
        posX = posX + speed;
        if (posX >= lastX) {
          isMoving = false;
          isForward = false;
          lastX = posX;
        }
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


