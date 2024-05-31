public class BounceBlock extends Sprite{
  public BounceBlock(PImage image, float scale){
    super(image, scale);
  }
   float getLeft(){
    return (center_x - w/2)+18;
  }
  float getRight(){
    return(center_x + w/2)-18;
  }
}
