public class StrongEnemy extends Enemy{
  public StrongEnemy(PImage img, float scale, float bLeft, float bRight){
     super(img, scale, bLeft, bRight);
     moveLeft = new PImage[3];
    moveLeft[0] = loadImage("spider_walk_left1red.png");
    moveLeft[1] = loadImage("spider_walk_left2red.png");
    moveLeft[2] = loadImage("spider_walk_left3red.png");
    moveRight = new PImage[3];
    moveRight[0] = loadImage("spider_walk_right1red.png");
    moveRight[1] = loadImage("spider_walk_right2red.png"); 
    moveRight[2] = loadImage("spider_walk_right3red.png"); 
    currentImages = moveRight;
    direction = RIGHT_FACING;
    boundaryLeft = bLeft;
    boundaryRight = bRight;
    change_x = 2;
     lives=1000000;
     
  }
 
  
  
}
