//The MIT License (MIT)
//Copyright (c) 2013 Wooyong Ee

//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

PFont f;
PImage paper;
String words;

boolean debugMode = true;

boolean isAnimatingKeyStrike;
boolean isAnimatingCarriageReturn;
boolean isForward;

float currentX, currentY;
float lineStartX, lineStartY;
float lastX;
float charwidth = 24;
float typeSpeed = 3;
float scrollUpSpeed = 4;
float returnSpeed = 0.18;
float easing = 0.5;

int gray = 96;
int lineLength = 25;
int bellLength = lineLength - 5;
int lineCharCount = 0;
int lineCount = 1;

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
  drawPage();
  drawDisplay();
}

void keyPressed() {
  if (isAnimatingKeyStrike || isAnimatingCarriageReturn)
  {
    // If animating, do not accept input;
    // Play stuck sound.
    return;
  }

  if (key==CODED) {
    // Special keys pressed. Do nothing.
    return;
  }

  if ((key==ENTER)||(key==RETURN)) 
  {
    returnSound.cue(0);
    returnSound.play();

    words = words + String.valueOf(key);
    lineCount++;
    lineCharCount =0;

    // Animate carriage return.
    isAnimatingCarriageReturn = true;
  }

  if (words.length() == lineLength)
  {
    // Play stuck sound. Do nothing.

    return;
  }

  if ((key==DELETE)||(key==BACKSPACE))
  {
    if (words.length() > 0)
    {
      // Remove last typed letter.
      words = words.substring(0, words.length() - 1);
      lineCharCount--;
      println("Word length: " + words.length());

      // Animate.
      isAnimatingKeyStrike = true;
      isForward = false;
    }
    else
    {
      // If no words type, don't keep going back.
      println("Word length == 0");
      isAnimatingKeyStrike = false;
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
  lineCharCount++;

  // Animate.
  isAnimatingKeyStrike = true;
  isForward = true;

  // Console out.
  // println("key: " + String.valueOf(key) + " value: " + int(key) + " code: " + keyCode);
}


void drawPage() {
  if (isAnimatingKeyStrike) {
    if (isForward) {
      // Shift the words left.
      currentX -= typeSpeed;
      if (lastX - currentX >= charwidth) {
        isAnimatingKeyStrike = false;
        lastX = currentX;
      }
    }
    else {
      // Shift the words right.
      currentX += typeSpeed;
      if (currentX >= lastX) {
        isAnimatingKeyStrike = false;
        isForward = true;
        lastX = currentX;
      }
    }
  }
  else if (isAnimatingCarriageReturn)
  {
    // Animate scroll-up first.
    if (currentY > lineStartY)
    {
      currentY -= scrollUpSpeed;
    }
    // Then animate return swipe.
    else if ( currentX < lineStartX)
    {
      // Add easing.
      float dx = lineStartX - currentX;
      if (abs(dx) > 1)
      {
        currentX += dx * easing;
      }
      else
      {
        currentX += returnSpeed;
      }
    }
    // Carriage return animation done.
    else
    {
      // Save lineStartX & Y
      isAnimatingCarriageReturn = false;
      currentX = width/2;
      lastX = currentX;
      lineStartX = currentX;
      
      //lineStartY = currentY;
    }
  }

  pushMatrix();
  background(gray);
  translate(currentX, currentY);
  image(paper, -100, -120, 820, 420);
  textFont(f);
  textAlign(LEFT, BASELINE);
  fill(0, 195);
  textSize(48);
  text(words, 0, 0);
  stroke(0, 0, 255);
  popMatrix();

  if (debugMode)
  {
    stroke(255, 51, 51);
    line(width/2, 0, width/2, height);
  }
}

void drawDisplay()
{
  if (debugMode)
  {
    textSize(32);
    text(lineCharCount, 10, 20);
    text("lineStart:" + lineStartX + ", " + lineStartY, 10, 50);
    text("current:" + currentX + ", " + currentY, 10, 80);
  }
}

void mousePressed()
{
  reset();
}

void reset()
{
  background(gray);

  // Init variables.
  isAnimatingKeyStrike = false;
  isForward = true;

  currentY = height/3;
  lineStartY = currentY;
  
  currentX = width/2; // currentX is horizontal position of the text;
  // currentX is the approximate width of each letter. Thus, the distance to move.
  lastX = currentX;
  lineStartX = lastX;

  words = "";
  lineCharCount = 0;
  lineCount = 0;
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





