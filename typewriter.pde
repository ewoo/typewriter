//The MIT License (MIT)
//Copyright (c) 2013 Wooyong Ee

//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

PFont f;
PImage paper;
String words;

boolean isMoving;
boolean isForward;
float posX;
float lastX;
float charwidth = 24;
float speed = 3;

int gray = 96;
int bellLength = 20;

Maxim maxim;
AudioPlayer keySound;
AudioPlayer spaceSound;
AudioPlayer bellSound;
AudioPlayer returnSound;

void setup()
{
  // Setup draw area.
  size(640, 360);
  smooth();
  frameRate(60);

  initSound();

  //f = createFont("Courier", 32, true);
  f = loadFont("OlivettiType2-48.vlw");
  paper = loadImage("ivory.jpg");

  // Get ready to start from scratch!
  reset();
}

void draw()
{
  drawText();
  drawDisplay();
}

void keyPressed() {
  if (isMoving)
  {
    // If animating, do not accept input;
    // Play stuck sound.
    return;
  }

  if (key==CODED) {
    // Special keys pressed. Do nothing.
    return;
  }

  if ((key==DELETE)||(key==BACKSPACE))
  {
    if (words.length() > 0)
    {
      // Remove last typed letter.
      words = words.substring(0, words.length() - 1);
      println("Word length: " + words.length());

      // Animate.
      isMoving = true;
      isForward = false;
    }
    else
    {
      println("Word length == 0");
      isMoving = false;
    }

    // Play back sound.
    spaceSound.cue(0);
    spaceSound.play();

    return;
  }

  if ((key==TAB)||(key==' '))
  {
    spaceSound.cue(0);
    spaceSound.play();
  }
  else if ((key==ENTER)||(key==RETURN)) 
  {
    returnSound.cue(0);
    returnSound.play();
  }
  else if ((key >= '!' && key <= '~'))
  {
    // Print only valid character. See ASCII chart.
    keySound.cue(0);
    keySound.play();
  }
  else
  {
    // Key we don't care about. Do nothing.
    return;
  }

  // Check if approaching right margin.
  if (words.length() == bellLength)
  {
    bellSound.cue(0);
    bellSound.play();
  }

  // Build text.
  words = words + String.valueOf(key);

  // Animate.
  isMoving = true;
  isForward = true;

  // Console out.
  // println("key: " + String.valueOf(key) + " value: " + int(key) + " code: " + keyCode);
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
      // Shift the words right.
      posX = posX + speed;
      if (posX >= lastX) {
        isMoving = false;
        isForward = true;
        lastX = posX;
      }
    }
  }

  pushMatrix();
  background(gray);
  translate(posX, height/3);
  image(paper, -100, -120, 820, 420);
  textFont(f);
  textAlign(LEFT, BASELINE);
  fill(0, 195);
  textSize(48);
  text(words, 0, 0);
  stroke(0, 0, 255);
  line(0, 0, charwidth, 0);
  popMatrix();

  stroke(255, 51, 51);
  line(width/2, 0, width/2, height);
}

void drawDisplay()
{
  textSize(32);
  text(words.length(), 10, 20);
}

void mousePressed()
{
  reset();
}

void reset()
{
  background(gray);

  // Init variables.
  isMoving = false;
  isForward = true;

  posX = width/2; // posX is horizontal position of the text;
  // posX is the approximate width of each letter. Thus, the distance to move.
  lastX = posX;

  words = "";
}

void initSound()
{
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

  // Tweak sound levels.
  keySound.volume(4);
  spaceSound.volume(5);
  bellSound.volume(1);
  returnSound.volume(7);
}

