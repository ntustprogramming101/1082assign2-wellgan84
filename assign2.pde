/*
writer: wei-yun kan
edit date: 21 april 2020
name: assign 2

*/

PImage title, startNormal, startHovered, restartNormal, restartHovered, gameover;
PImage bg, soil, life, hogIdle, hogDown, hogLeft, hogRight, soldier, cabbage;

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState = GAME_START;


final int BUTTON_WIDTH = 144;
final int BUTTON_HEIGHT = 60;
final int BUTTON_TOP = 360;
final int BUTTON_BOTTOM = BUTTON_TOP + BUTTON_HEIGHT;
final int BUTTON_LEFT = 248;
final int BUTTON_RIGHT = BUTTON_LEFT + BUTTON_WIDTH;

final int GRID = 80;
final int GRASS_HEIGHT = 15;
final int LIFE_WIDTH = 50;
final int LIFE_GAP = 20;
final int HOG_WIDTH = 80;

int soldierX, soldierY, soldierSpeed;
float hogIdleX = GRID*4;
float hogIdleY = 80;
int lifeOneX = 10;
int lifeOneY = 10;
int lifeTwoX = lifeOneX + LIFE_WIDTH + LIFE_GAP;
int lifeThreeX;
int cabbageX, cabbageY;

// hog's move
int MoveTime = 250;
int actionFrame = 0;
float lastTime;
float hogLestY, hogLestX;

boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
// boolean noPressed = true;

void setup() {
	size(640, 480, P2D);
  title = loadImage("img/title.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  gameover = loadImage("img/gameover.jpg");
  bg = loadImage("img/bg.jpg");
  soil = loadImage("img/soil.png");
  life = loadImage("img/life.png");
  cabbage = loadImage("img/cabbage.png");
  soldier = loadImage("img/soldier.png");
  hogIdle = loadImage("img/groundhogIdle.png");
  hogDown = loadImage("img/groundhogDown.png");
  hogLeft = loadImage("img/groundhogLeft.png");
  hogRight = loadImage("img/groundhogRight.png");
  
  // decide soidier's initial y position & speed
  soldierY = floor(random(2,6)) * 80;
  soldierSpeed = 4;
  
  // decide vegetable's initial position
  cabbageX = floor(random(0,7)) * GRID;
  cabbageY = floor(random(2,6)) * GRID;
  
  // first only have 2 lifes, so let Life3 out 
  lifeThreeX = width;
  
  frameRate(60);
  gameState = GAME_START;
  lastTime = millis();
}

void draw() {
  
  switch(gameState){
    case GAME_START:
      if(mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT
      && mouseY > BUTTON_TOP && mouseY < BUTTON_BOTTOM){
        image(startHovered, BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
        if(mousePressed){
          gameState = GAME_RUN;
        }
      }else{
        image(title, 0, 0);
        image(startNormal, BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
      }
    break;
    
    case GAME_RUN:
    // set background & soil image
    image(bg,0,0);
    image(soil,0,GRID * 2);
    // grass
    fill(124,204,25);
    noStroke();
    rect(0, GRID*2 - GRASS_HEIGHT, width, GRASS_HEIGHT);
    // sun
    ellipseMode(CENTER);
    stroke(255, 255, 0);
    strokeWeight(5);
    fill(253, 184, 19);
    ellipse(590,50,120,120);
    // life
    life = loadImage("img/life.png");
    image(life, lifeOneX, lifeOneY);
    image(life, lifeTwoX, lifeOneY);
    image(life, lifeThreeX, lifeOneY);
    
    // decide hog's direction
    if (downPressed == false && leftPressed == false && rightPressed == false) {
      image(hogIdle, hogIdleX, hogIdleY);
    }
    if (downPressed){
      actionFrame++;
      if (actionFrame > 0 && actionFrame < 15){
        hogIdleY += GRID/15.0;
        image(hogDown, hogIdleX, hogIdleY);
        if (hogIdleY >= GRID*5){
          hogIdleY = GRID*5;
        } 
      } else{
        hogIdleY = hogLestY + GRID;
        downPressed = false;
      }
    } 
    if (leftPressed){
      actionFrame++;
      if (actionFrame > 0 && actionFrame < 15){
        hogIdleX -= GRID/15.0;
        image(hogLeft, hogIdleX, hogIdleY);
        if (hogIdleX < GRID){
          hogIdleX = 0;
        } 
      } else{
        hogIdleX = hogLestX - GRID;
        leftPressed = false;
      }
    } 
    if (rightPressed){
      actionFrame++;
      if (actionFrame > 0 && actionFrame < 15){
        hogIdleX += GRID/15.0;
        image(hogRight, hogIdleX, hogIdleY);
        if (hogIdleX > GRID*7){
          hogIdleX = GRID*7;
        } 
      } else{
        hogIdleX = hogLestX + GRID;
        rightPressed = false;
      }
    }
    
    //groundhog: boundary detection
    if (hogIdleX >= width - GRID) {
      hogIdleX = width - GRID;
    }
    if (hogIdleX <= 0) {
      hogIdleX = 0;
    }
    if (hogIdleY >= height - GRID) {
      hogIdleY = height - GRID;
    }
    if (hogIdleY <= 0) {
      hogIdleY = 0;
    }
    
    // how many life ( life's x position should on "width" when the hog don't have it )
    image(cabbage,cabbageX,cabbageY);
    if (hogIdleX == cabbageX && hogIdleY == cabbageY){
      if (lifeTwoX == width) {
        cabbageX = width;
        lifeTwoX = lifeOneX + LIFE_WIDTH + LIFE_GAP;
      } else if (lifeTwoX != width){
        cabbageX = width;
        lifeThreeX = lifeOneX + LIFE_WIDTH*2 + LIFE_GAP*2;
      }
    }
    
    // show soldier
    image(soldier,soldierX,soldierY);
    soldierX += soldierSpeed;
    if (soldierX > 640){
      soldierX = -25;
    } // X position reset
    
    // when hog meet soldier
    if (hogIdleX > soldierX - HOG_WIDTH && hogIdleX < soldierX + HOG_WIDTH){
      if (hogIdleY == soldierY){
        if (lifeThreeX != width){
          hogIdleX = GRID*4;
          hogIdleY = 80;
          lifeThreeX = width;
          // life 3 -> 2
        }
        else if (lifeTwoX != width){
          hogIdleX = GRID*4;
          hogIdleY = 80;
          lifeTwoX = width;
          // life 2 -> 1
        } else{
           hogIdleY = 80;
           lifeTwoX = width;
           gameState = GAME_OVER;
           // life 1 -> 0 = gameover
        }
      }
    }
    
    break;
    
    case GAME_OVER:
      image(gameover, 0, 0);
      if(mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT
      && mouseY > BUTTON_TOP && mouseY < BUTTON_BOTTOM){
        image(restartHovered, BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
        if(mousePressed){
          gameState = GAME_RUN;
          // reset 2 lifes
          lifeTwoX = lifeOneX + LIFE_WIDTH + LIFE_GAP;
          lifeThreeX = width;
          // decide cabbage & soldier's position
          cabbageX = floor(random(0,7)) * GRID;
          cabbageY = floor(random(2,6)) * GRID;
          soldierY = floor(random(2,6)) * 80;
        }
      }else{
        image(restartNormal, BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
      }
    break;
  }
}

void keyPressed(){
  float newTime = millis();
  if (key == CODED) {
    switch (keyCode) {
      case DOWN:
        if (newTime - lastTime > 250){
          downPressed = true;
          actionFrame = 0;
          hogLestY = hogIdleY;
          lastTime = newTime;
        }
        break;
      case LEFT:
        if (newTime - lastTime > 250){
          leftPressed = true;
          actionFrame = 0;
          hogLestX = hogIdleX;
          lastTime = newTime;
        }
        break;
      case RIGHT:
        if (newTime - lastTime > 250){
          rightPressed = true;
          actionFrame = 0;
          hogLestX = hogIdleX;
          lastTime = newTime;
        }
      break;
    }
  } 
}
