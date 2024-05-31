import processing.sound.*;

/*
  Scrolling Platformer Lab:
  
  Add scrolling ability to the player. 
  
  For more detail, see the tutorial: 
  Scrolling: https://www.youtube.com/watch?v=y4smwQ794_M
  
  
  Complete the code as indicated by the comments.
  Do the following:
  1) You'll need implement the method scroll() below. Use the view_x and view_y variables
  already declared and initialized. 
  2) Call scroll() in draw().
  See the comments below for more details. 
 
*/

final static float COIN_SCALE = 0.4;
final static float SPRITE_SCALE = 50.0/128; 
final static float SPRITE_SIZE = 50;
final static float SPRITE_SIZE_LARGE= 100;
final static float GRAVITY = .6;
final static float JUMP_SPEED = 14; 
final static float WIDTH= SPRITE_SIZE*16;
final static float HEIGHT= SPRITE_SIZE*12;
final static float GROUND_LEVEL=HEIGHT- SPRITE_SIZE;
final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 55;

final static int NEUTRAL_FACING = 0; 
final static int RIGHT_FACING = 1; 
final static int LEFT_FACING = 2; 

final static float MOVE_SPEED = 4;





//declare global variables
Player player;
int numCoins;
PImage playerImage;
PImage snow, crate, red_brick, brown_brick, spider,c, cloud, poisonBlock, mushroom, redSpider, bounceBlock;
ArrayList<Sprite> platforms;
ArrayList<Enemy> enemies;
float view_x;
float view_y;
ArrayList<Coin> coins;
ArrayList<Mushroom> mushrooms;
ArrayList<Poison> poisons;
boolean isGameOver;
SoundFile mainTheme, coinSound, jumpSound, enemySound, fallSound, winSound, loseSound, stomp, breakBrick, drown, oneUp;
int songNum;
int playCount;
BossEnemy theEnemy;
boolean returnCheck;
int levelNum;

//initialize them in setup().
void setup(){
  size(800, 600);
  playerImage = loadImage("player_stand_right.png");
  imageMode(CENTER);
  player = new Player(playerImage, 0.75);
  isGameOver=false;
  player.center_x = 200;
  //player.center_x=5825;
  player.center_y = GROUND_LEVEL;
  platforms = new ArrayList<Sprite>();
  mushrooms=new ArrayList<Mushroom>();
  numCoins=0;
  levelNum=1;
  red_brick = loadImage("red_brick.png");
  brown_brick = loadImage("brown_brick.png");
  crate = loadImage("crate.png");
  snow = loadImage("snow.png");
  spider = loadImage("spider_walk_right1.png");
  redSpider = loadImage("spider_walk_right1red.png");
  coins=new ArrayList<Coin>();
  c= loadImage("gold1.png");
  cloud= loadImage("pinpng.com-gas-cloud-png-3957662.png");
  poisonBlock= loadImage("NicePng_tetris-blocks-png_7771728.png");
  mushroom= loadImage("pinpng.com-super-mario-mushroom-png-5816759.png");
  bounceBlock=loadImage("output-onlinepngtools.png");
  enemies=new ArrayList<Enemy>();
  coins=new ArrayList<Coin>();
  poisons= new ArrayList<Poison>();
  createPlatforms("map.csv");
  view_x = 0;
  view_y = 0;
  returnCheck=false;
  songNum=(int) (Math.random()*6);
  if (songNum==0){
    mainTheme=new SoundFile(this,"«Super Mario World» - Music Overworld Theme (Nintendo,1990,SNES).mp3");
  }
  else if (songNum==1){
    mainTheme=new SoundFile(this, "1-17 Gusty Garden Galaxy.mp3");
  }
  else if (songNum==2){
    mainTheme= new SoundFile(this,"1-16 Buoy Base Galaxy.mp3");
  }
  else if (songNum==3){
    mainTheme=new SoundFile(this, "1-03 - Super Bell Hill.mp3");
  }
  else if (songNum==4){
     mainTheme= new SoundFile(this, "1-15 Tostarena Ruins.mp3");
  }
  else{
    mainTheme= new SoundFile(this,"1-28 Freezy Flake Galaxy.mp3");
  }

  
  coinSound= new SoundFile(this,"super-mario-world-coin (1)-[AudioTrimmer.com] (1).mp3");
  jumpSound=new SoundFile(this, "maro-jump-sound-effect_1 (2).mp3");
  enemySound= new SoundFile(this, "super-mario-bros.mp3");
  fallSound= new SoundFile(this, "Mario Fall Waa Sound Effect.mp3");
  winSound= new SoundFile(this, "1-06 - Course Clear.mp3");
  loseSound=new SoundFile(this, "2-27 - Miss.mp3");
  stomp= new SoundFile(this, "smb_stomp (2) (1).wav");
  breakBrick= new SoundFile(this, "smb_breakblock (1).wav");
  oneUp= new SoundFile(this, "smw_1-up (1).wav");
  
  mainTheme.play();
  playCount=0;
}

// modify and update them in draw().
void draw(){
  if (songNum==0|| songNum==1 ||songNum==3){
    background(135,206,235);
  }
  else if (songNum==5){
    background(217, 241, 255);
  }
  else if (songNum==2){
    background(10, 63, 94); 
  }
  else if (songNum==4){
    background(232, 146, 32); 
  }
  
  
  
  // call scroll here. Need to call scroll first!
  scroll();
  resolvePlatformCollisions(player, platforms);
  displayAll();
  if (!isGameOver){
    updateAll();
    collectCoins();
    breakBlocks(player);
    defeatEnemies();
    checkDeath();
  }
  else{
    player.change_x=0;
    player.change_y=0;
  }

} 
void displayAll(){
  for(Sprite s: platforms)
    s.display();
   for (Coin c: coins){
    c.display(); 
  }
  for (Enemy e: enemies){
    e.display();
  }
  for (Poison p: poisons){
    p.display();
  }  
  for (Mushroom m: mushrooms){
    m.display(); 
  }
  player.display();
  fill(255,0,0);
  textSize(32);
  text("Coins:" + numCoins, view_x+50, view_y+50);
  text("Lives:" + player.lives, view_x+50, view_y+100);
  text("Level:" + levelNum, view_x+50, view_y+150);
  if (isGameOver){
     mainTheme.stop();
     text("GAME OVER!", view_x+ width/2-200, view_y+height/2);
     if (player.lives==0){
        text("You lose! Try again!", view_x+width/2, view_y+height/2);
        if (playCount==0){
        loseSound.play();
        playCount++;
        }
     }
     else{
         text("You win! :)", view_x+width/2+60, view_y+height/2);
         if (playCount==0){
         winSound.play();
         playCount++;
         }
     }
     text("Press SPACE to play again!", view_x+width/2-170, view_y+height/2+100);
  }
}
void updateAll(){
  player.updateAnimation();
  for (Coin c: coins){
    ((AnimatedSprite)c).updateAnimation();
  }
  for (Enemy e: enemies){
    e.update();
    e.updateAnimation();
  }
  collectCoins();
  bouncing(player, platforms);
}
void returnDeath(){
   if (returnCheck){
     //wherever it is
     player.center_x=5825;
   }
   else{
     player.center_x=200; 
     //player.center_x=5825;
   }
}
void scroll(){
  
  // create and initialize left_boundary variable
  // Hint: left_boundary = view_x + LEFT_MARGIN
  float left_boundary=view_x+LEFT_MARGIN;
  // if player's left < left_boundary
  if (player.getLeft()<left_boundary){
    view_x-=left_boundary-player.getLeft();
  }
  //     view_x -= (left_boundary - player's left);     

  
  
  // create and initialize right_boundary variable
  // Hint: right_boundary = view_x + width - RIGHT_MARGIN;
  float right_boundary=view_x+width-RIGHT_MARGIN;
  if (player.getRight()>right_boundary){
    view_x+=player.getRight()-right_boundary;
  } 
  
  // if player's right > right_boundary
  //     view_x += player's right - right_boundary;    

  
  

  // create and initialize top_boundary variable
  // Hint: top_boundary = view_y + VERTICAL_MARGIN;
  float top_boundary=view_y+VERTICAL_MARGIN;
  if (player.getTop()<top_boundary){
    view_y-=top_boundary-player.getTop();
  }
  
  
  // if player's top < top_boundary
  //   view_y -= top_boundary - player's top;


  
  
  // create and initialize bottom_boundary variable
  // Hint: bottom_boundary = view_y + height - VERTICAL_MARGIN;
  float bottom_boundary=view_y+height-VERTICAL_MARGIN;
  if (player.getBottom()>bottom_boundary){
     view_y+=player.getBottom()-bottom_boundary; 
  }
  
  // if player's bottom > bottom_boundary
  //    view_y += player's bottom - bottom_boundary;

  
  // call translate(-view_x, -view_y)
  translate(-view_x,-view_y);


}
void collectCoins(){
  ArrayList<Sprite> collision_list = checkCollisionList(player, coins);
  ArrayList<Sprite> mushTouched= checkCollisionList(player, mushrooms);
  if(collision_list.size() > 0 || mushTouched.size()>0){
    for(Sprite coin: collision_list){
       numCoins++;
       coinSound.play();
       coins.remove(coin);
    } 
    for (Sprite m: mushTouched){
       player.lives++; 
       oneUp.play();
       mushrooms.remove(m);
    }
    //check to see if all coins collected in area 1
    if (coins.size()==18){
      //wherever it is
      player.center_x=5825;
      player.change_y=0;
      returnCheck=true;
      levelNum=2;
    }
    
    else if (coins.size()==0 ){
       isGameOver=true; 
    }
}

}


public boolean broken(Sprite s, Breakable b){
    s.center_y-=5;
    boolean overlapped=checkCollision(s, b);
    boolean botTouched = (s.getTop() <= b.getBottom());
    s.center_y+=5;
    if(overlapped && botTouched && s.change_y<=0){
    //play breaking noise
    s.change_y=0;
    breakBrick.play();
    return true;
  }
  else{
    return false;
  } 

}
public ArrayList<Sprite> brokenList(Player c){
  ArrayList<Sprite> brokenBlocks= new ArrayList<Sprite>();
  for (Sprite s: platforms){
    if ((s instanceof Breakable) && broken(c, (Breakable)s)){
       brokenBlocks.add(s);
    }
  }
  return brokenBlocks;
}
void breakBlocks(Player c){
   ArrayList<Sprite> brokenBlocks= brokenList(c);
   if (brokenBlocks.size()>0){
     for (Sprite b: brokenBlocks){
        platforms.remove(b); 
     }
   }
}
public void bouncing(Sprite s, ArrayList<Sprite> p){
    s.center_y+=5;
    for (Sprite e: p){
    boolean overlapped=checkCollision(s,e);
    boolean topTouched= (s.getBottom()>=e.getTop());
    if(overlapped && topTouched && (e instanceof BounceBlock)){
    player.change_y= -JUMP_SPEED*2.0;
    stomp.play();
    }
  }
  s.center_y-=5;
}
public boolean defeat(Sprite s, Sprite e){
    s.center_y += 5;
    boolean overlapped=checkCollision(s, e);
    boolean topTouched = (s.getBottom() >= e.getTop()) ;
    s.center_y-=5;
  if(overlapped && topTouched && s.change_y>0 && !(e instanceof StrongEnemy)){
    stomp.play();
    return true;
  }
  else{
    return false;
  } 
}
public ArrayList<Enemy> defeatedEnemiesList(Player s){
  ArrayList<Enemy> defeated= new ArrayList<Enemy>();
  for (Enemy e: enemies){
    if (defeat(s, e)){
      defeated.add(e);
    }
  }
  return defeated;
}

boolean defeatEnemies(){
   ArrayList<Enemy> defeated= defeatedEnemiesList(player);
   if (defeated.size()>0){
     for (Enemy e: defeated){
       if (e instanceof BossEnemy){
           player.change_y= -JUMP_SPEED*2.0;
       }
       else{
       player.change_y = -JUMP_SPEED*0.5;
       }
       e.decreaseLives();
       if (e.lives==0){
        enemies.remove(e); 
     }
   }
   return true;
}
return false;
}
boolean checkPoison(){

  return isOnPlatforms(player, poisons);
 
}
void checkDeath(){
  ArrayList<Sprite> collideEnemy =checkCollisionList(player,enemies); 
  //ArrayList<Enemy> defeatedEnemies= defeatedEnemiesList(player);
  boolean fallOffCliff=player.getBottom()>GROUND_LEVEL+200;
  if ((collideEnemy.size()> 0) || fallOffCliff || checkPoison()){
    player.lives--;
    if(player.lives==0){
      isGameOver=true; 
      return;
    }
     else {
     returnDeath();
     //player.center_x=200;
     player.setBottom(GROUND_LEVEL);
     if (collideEnemy.size()>0){
       enemySound.play(); 
     }
    else {
      fallSound.play();
    }
    }
    
    
   
  }
}

// returns true if sprite is one a platform.
public boolean isOnPlatforms(Sprite s, ArrayList<? extends Sprite> walls){
  // move down say 5 pixels
  s.center_y += 5;

  // check to see if sprite collide with any walls by calling checkCollisionList
  ArrayList<Sprite> collision_list = checkCollisionList(s, walls);
  
  // move back up 5 pixels to restore sprite to original position.
  s.center_y -= 5;
  
  // if sprite did collide with walls, it must have been on a platform: return true
  // otherwise return false.
  return collision_list.size() > 0; 
}


// Use your previous solutions from the previous lab.

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  // add gravity to change_y of sprite
  if(!isGameOver){
  s.change_y += GRAVITY;
  s.center_y += s.change_y;
  }
  // move in y-direction by adding change_y to center_y to update y position.
  
  
  // Now resolve any collision in the y-direction:
  // compute collision_list between sprite and walls(platforms).
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  
  /* if collision list is nonempty:
       get the first platform from collision list
       if sprite is moving down(change_y > 0)
         set bottom of sprite to equal top of platform
       else if sprite is moving up
         set top of sprite to equal bottom of platform
       set sprite's change_y to 0
  */
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_y > 0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y < 0){
      s.setTop(collided.getBottom());
    }


    s.change_y = 0;
    
  }

  // move in x-direction by adding change_x to center_x to update x position.
  s.center_x += s.change_x;
  
  // Now resolve any collision in the x-direction:
  // compute collision_list between sprite and walls(platforms).   
  col_list = checkCollisionList(s, walls);

  /* if collision list is nonempty:
       get the first platform from collision list
       if sprite is moving right
         set right side of sprite to equal left side of platform
       else if sprite is moving left
         set left side of sprite to equal right side of platform
  */

  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_x > 0){
        s.setRight(collided.getLeft());
    }
    else if(s.change_x < 0){
        s.setLeft(collided.getRight());
    }
  }
}

boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = (s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight() || ( s2 instanceof TransparentSprite)) ;
  boolean noYOverlap = (s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom() || (s2 instanceof TransparentSprite)) ;
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<? extends Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){

      
     if(checkCollision(s, p)){
      collision_list.add(p);
    }

  }
  return collision_list;
}


void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++){
       if(values[col].equals("a")){
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("b")){
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("c")){
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("d")){
        Breakable s = new Breakable(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("e")){
       Coin coin = new Coin(c, COIN_SCALE/1.2);
       coin.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
       coin.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
       coins.add(coin); 
      }
      else if (values[col].equals("f")){
        TransparentSprite s = new TransparentSprite(cloud, SPRITE_SCALE/1.5);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("g")){
        float bLeft = col*SPRITE_SIZE;
        float bRight = bLeft+ 6*SPRITE_SIZE;
        BossEnemy s= new BossEnemy(spider,100/72.0, bLeft, bRight);
        s.center_x = (SPRITE_SIZE/2+col*SPRITE_SIZE);      // see cases above.
        s.center_y = (SPRITE_SIZE/2+row*SPRITE_SIZE)-10;
        // add enemy to enemies arraylist.
        enemies.add(s);
      }
       else if (values[col].equals("h")){
        float bLeft = col*SPRITE_SIZE;
        float bRight = bLeft+3*SPRITE_SIZE;
        BossEnemy s= new BossEnemy(spider,100/72.0, bLeft, bRight);
        s.center_x = (SPRITE_SIZE/2+col*SPRITE_SIZE);      // see cases above.
        s.center_y = (SPRITE_SIZE/2+row*SPRITE_SIZE)-10;
        // add enemy to enemies arraylist.
        enemies.add(s);
      }
      else if (values[col].equals("i")){
        Poison s = new Poison (poisonBlock,21/144.0);
        //23/144.0
        s.center_x = SPRITE_SIZE/2+col*SPRITE_SIZE;  
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;// see cases above.
        poisons.add(s);
      }
      else if (values[col].equals("j")){
        float bLeft = col*SPRITE_SIZE;
        float bRight = bLeft+ 5*SPRITE_SIZE;
        BossEnemy s= new BossEnemy(spider,100/72.0, bLeft, bRight);
        s.center_x = (SPRITE_SIZE/2+col*SPRITE_SIZE);      // see cases above.
        s.center_y = (SPRITE_SIZE/2+row*SPRITE_SIZE)-10;
        // add enemy to enemies arraylist.
        enemies.add(s);
      }
      else if (values[col].equals("k")){
       Coin coin = new Coin(c, COIN_SCALE/1.2);
       coin.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
       coin.center_y = (SPRITE_SIZE/2 + row * SPRITE_SIZE);
       coins.add(coin); 
        Breakable s = new Breakable(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
       
       
      }
       else if (values[col].equals("l")){
         Breakable s = new Breakable(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
        int lengthGap = 3;
        float bLeft = col*SPRITE_SIZE;
        float bRight = bLeft+lengthGap*SPRITE_SIZE;
        Mushroom m= new Mushroom(mushroom, 6/72.0, bLeft, bRight);
        m.center_x=SPRITE_SIZE/2+col*SPRITE_SIZE;      // see cases above.
        m.center_y = SPRITE_SIZE/2+row*SPRITE_SIZE;
        mushrooms.add(m);
         
         
       }  
       else if (values[col].equals("m")){
         BounceBlock s = new BounceBlock (bounceBlock,21/144.0);
        s.center_x = SPRITE_SIZE/2+col*SPRITE_SIZE;  
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;// see cases above.
        platforms.add(s);
       }
      else if(values[col].equals("0")){
        continue; // continue with for loop, i.e do nothing.
      }
      else{
        // use Processing int() method to convert a numeric string to an integer
        // representing the walk length of the spider.
        // for example int a = int("9"); means a = 9.
        int val= int(values[col]);
        if (val<10){
        int lengthGap = int(values[col]);
        float bLeft = col*SPRITE_SIZE;
        float bRight = bLeft+lengthGap*SPRITE_SIZE;
        Enemy enemy = new Enemy (spider,50/72.0,bLeft,bRight);
        enemy.center_x = SPRITE_SIZE/2+col*SPRITE_SIZE;      // see cases above.
        enemy.center_y = SPRITE_SIZE/2+row*SPRITE_SIZE;
        // add enemy to enemies arraylist.
        enemies.add(enemy);
        } else {
          int lengthGap = val%10;
        float bLeft = col*SPRITE_SIZE;
        float bRight = bLeft+lengthGap*SPRITE_SIZE;
        StrongEnemy enemy = new StrongEnemy(redSpider,50/72.0,bLeft,bRight);
        enemy.center_x = SPRITE_SIZE/2+col*SPRITE_SIZE;      // see cases above.
        enemy.center_y = SPRITE_SIZE/2+row*SPRITE_SIZE;
        enemies.add(enemy);
        }
    }
    
    
    }
  }
}
 

// called whenever a key is pressed.
void keyPressed(){
  if(keyCode == RIGHT && !isGameOver){
    player.change_x = MOVE_SPEED;
  }
  else if(keyCode == LEFT && !isGameOver){
    player.change_x = -MOVE_SPEED;
  }
  // add an else if and check if key pressed is 'a' and if sprite is on platforms
  // if true then give the sprite a negative change_y speed(use JUMP_SPEED)
  // defined above
  else if(key == 'a' && isOnPlatforms(player, platforms) && !isGameOver){
    player.change_y = -JUMP_SPEED;
    jumpSound.play();
  }
  else if (key == 'f'){
     
  }
  else if (isGameOver && key==' '){
    setup(); 
  }

}

// called whenever a key is released.
void keyReleased(){
  if(keyCode == RIGHT){
    player.change_x = 0;
  }
  else if(keyCode == LEFT){
    player.change_x = 0;
  }
  else if (keyCode=='f'){

  }
  
}
