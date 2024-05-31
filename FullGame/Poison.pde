public class Poison extends AnimatedSprite{
   float boundaryLeft, boundaryRight;
   public Poison(PImage img, float scale){
      super(img, scale);
      direction=NEUTRAL_FACING;
      index=0;
      frame=0;
      standNeutral=new PImage[1];
      standNeutral[0]=loadImage("NicePng_tetris-blocks-png_7771728.png");
      moveLeft=new PImage[1];
      moveLeft[0]=loadImage("NicePng_tetris-blocks-png_7771728.png");
      moveRight= new PImage[1];
      moveRight[0]=loadImage("NicePng_tetris-blocks-png_7771728.png");
    
   }
  
 
  float getLeft(){
    return (center_x - w/2)+18;
  }
  float getRight(){
    return(center_x + w/2)-18;
  }
  

   
}
