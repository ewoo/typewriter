/* @pjs font="Arial.ttf"; */
PFont f, infoFont;
PImage paper;
var words = null;

boolean debugMode = false;

boolean isAnimatingKeyStrike = false;
boolean isAnimatingCarriageReturn = false;
boolean isForward = false;

int viewportY;
float currentX, currentY;
float lineStartX, lineStartY;
float lastX;
int charwidth = 24;
int lineHeight = 48;
float typeSpeed = 3;
float scrollUpSpeed = 3;
float returnSpeed = 0.08;
float easing = 0.08;

int gray = 96;
int lineLength = 26;
int bellLength = lineLength - 5;
int lineCharCount = 0;
int lineCount = 1;
int lineCountLimit = 8;

Maxim maxim;
AudioPlayer keySound, spaceSound, bellSound, returnSound;

function setup() {
  size(640, 280);
  smooth();
  frameRate(60);

  initSound();

  infoFont = createFont("Courier", 10, true);
  f = loadFont("OlivettiType2-48.vlw");
  paper = loadImage("white-stock.jpg");

  viewportY = height / 2;

  reset();
}

function draw() {
  drawPage();
  drawDisplay();
}

function keyPressed() {
  if (isAnimatingKeyStrike || isAnimatingCarriageReturn) {
    return;
  }

  if (key == CODED) {
    return;
  }

  if ((key == ENTER) || (key == RETURN)) {
    if (lineCount == lineCountLimit) {
      spaceSound.cue(0);
      spaceSound.play();
      return;
    }

    returnSound.cue(0);
    returnSound.play();

    words = words + String.valueOf(key);
    lineCount++;
    lineCharCount = 0;

    isAnimatingCarriageReturn = true;
  }

  if (lineCharCount == lineLength) {
    spaceSound.cue(0);
    spaceSound.play();
    return;
  }

  if ((key == DELETE) || (key == BACKSPACE)) {
    if (words.length > 0) {
      words = words.substring(0, words.length - 1);
      lineCharCount--;

      isAnimatingKeyStrike = true;
      isForward = false;
    }
    else {
      isAnimatingKeyStrike = false;
    }

    spaceSound.cue(0);
    spaceSound.play();

    return;
  }

  if ((key == TAB) || (key == (new Character(' ')))) {
    spaceSound.cue(0);
    spaceSound.play();
  } 
  else if ((key >= (new Character('!')) && key <= (new Character('~')))) {
    keySound.cue(0);
    keySound.play();
  } 
  else {
    return;
  }

  if (lineCharCount == bellLength) {
    bellSound.cue(0);
    bellSound.play();
  }

  words = words + String.valueOf(key);
  lineCharCount++;

  isAnimatingKeyStrike = true;
  isForward = true;
}

function drawPage() {
  if (isAnimatingKeyStrike) {
    if (isForward) {
      currentX -= typeSpeed;
      if (lastX - currentX >= charwidth) {
        isAnimatingKeyStrike = false;
        lastX = currentX;
      }
    } 
    else {
      currentX += typeSpeed;
      if (currentX >= lastX) {
        isAnimatingKeyStrike = false;
        isForward = true;
        lastX = currentX;
      }
    }
  } 
  else if (isAnimatingCarriageReturn) {
    if (currentY > lineStartY) {
      currentY -= scrollUpSpeed;
    } 
    else if (currentX < lineStartX) {
      var dx = lineStartX - currentX;
      if (abs(dx) > 1) {
        currentX += dx * easing;
      } 
      else {
        currentX += returnSpeed;
      }
    } 
    else {
      currentX = width / 2;
      lastX = currentX;
      lineStartX = currentX;
      lineStartY -= lineHeight;
      isAnimatingCarriageReturn = false;
    }
  }

  pushMatrix();
  background(gray);
  translate(currentX, currentY);
  image(paper, -100, -120, 820, 540);
  textFont(f);
  textAlign(LEFT, BASELINE);
  fill(0, 195);
  textSize(48);
  text(words, 0, 0);
  stroke(0, 0, 255);
  popMatrix();

  if (debugMode) {
    stroke(255, 51, 51);
    line(width / 2, 0, width / 2, height);
    line(0, viewportY, width, viewportY);
  }
}

function drawDisplay() {
  if (debugMode) {
    var fsize = 10;
    var y = 20;
    textFont(infoFont);
    textSize(10);
    text("Debug Info:", 10, y);
    text("lineCharCount:" + lineCharCount, 10, y + fsize);
    text("lineStart(x,y):(" + lineStartX + ", " + lineStartY + ")", 10, y + fsize * 2);
    text("current(x,y):(" + currentX + ", " + currentY + ")", 10, y + fsize * 3);
  }
}

function mousePressed() {
  if (debugMode) {
    reset();
  }
}

function reset() {
  background(gray);

  isAnimatingKeyStrike = false;
  isForward = true;

  currentY = viewportY;
  lineStartY = currentY - lineHeight;

  currentX = width / 2;
  lastX = currentX;
  lineStartX = lastX;

  words = "";
  lineCharCount = 0;
  lineCount = 0;
}

function initSound() {
  maxim = new Maxim(this);

  keySound = maxim.loadFile("keystrike.wav");
  spaceSound = maxim.loadFile("spacebar.wav");
  bellSound = maxim.loadFile("bell.wav");
  returnSound = maxim.loadFile("carriagereturn.wav");

  keySound.setLooping(false);
  spaceSound.setLooping(false);
  bellSound.setLooping(false);
  returnSound.setLooping(false);

  keySound.volume(4);
  spaceSound.volume(5);
  bellSound.volume(1);
  returnSound.volume(7);
}
