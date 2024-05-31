public class Mushroom extends Coin{
  float boundaryLeft, boundaryRight;
  public Mushroom( PImage img, float scale,float bLeft, float bRight ){
    super (img,scale);
   boundaryLeft = bLeft;
    boundaryRight = bRight;
    change_x=0;
    index=0;
  
  
   standNeutral = new PImage[4];
    standNeutral[0] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png");
    standNeutral[1] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png");
    standNeutral[2] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png");
    standNeutral[3] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png");
    moveLeft = new PImage[3];
    moveLeft[0] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png");
    moveLeft[1] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png");
    moveLeft[2] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png");
    moveRight = new PImage[3];
    moveRight[0] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png");
    moveRight[1] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png"); 
    moveRight[2] = loadImage("pinpng.com-super-mario-mushroom-png-5816759.png"); 
    currentImages=standNeutral;
  }

  void update(){
    // call update of Sprite(super)
    super.update();
    
    if (getLeft()<=boundaryLeft){
       setLeft(boundaryLeft);
       change_x *= -1;
    }
    else if (getRight()>=boundaryRight){
       setRight(boundaryRight);
       change_x *= -1;
    }
  }
}
