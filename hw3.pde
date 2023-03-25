import ddf.minim.*;
import processing.sound.*;

PImage spaceShip,bg,bg2,treasure,bullet,startPageBg,startBtn,resultPageBg,playAgainBtn,exitBtn;
int numFrames = 9,enemyNum = 2;
PImage[] images = new PImage[numFrames];
PImage[] enemy = new PImage[enemyNum];
PImage[] volumeImg = new PImage[2];
PImage[] soundImg = new PImage[2];
PImage[] pauseImg = new PImage[2];
IntList enemyKind,enemyX,enemyY,bulletX,bulletY;
PFont font;
int blood = 0,score = 0,bulletNum = 0,treasureNum = 0,sound,volume,pause = 0,enemyTime,enemySpeed,level;
int treasureX,treasureY,treasureTime,treasureShow;
int page = 0;
Minim minim;
SoundFile bgSong,shootSound,bombSound,treasureSound;


void setup(){
  size(710,950);
  minim = new Minim(this);
  bgSong = new SoundFile(this,"\\src\\bgMusic.mp3");
  bombSound = new SoundFile(this,"\\src\\bombSound.wav");
  shootSound = new SoundFile(this,"\\src\\shoot.wav");
  treasureSound = new SoundFile(this,"\\src\\coin.mp3");
  bgSong.amp(0.4);
  bombSound.amp(0.5);
  shootSound.amp(0.7);
  bgSong.loop();
  treasureShow = 0;
  spaceShip = loadImage("\\src\\spaceShip.png");
  treasure = loadImage("\\src\\treasure.png");
  bg = loadImage("\\src\\background.jpg");
  bg2 = loadImage("\\src\\background.jpg");
  bullet = loadImage("\\src\\bullet.png");
  soundImg[0] = loadImage("\\src\\volume_off.png");
  soundImg[1] = loadImage("\\src\\volume_on_1.png");
  volumeImg[0] = loadImage("\\src\\mute2.png");
  volumeImg[1] = loadImage("\\src\\volume2.png");
  startPageBg = loadImage("\\src\\startPage.jpg");
  startBtn = loadImage("\\src\\startBtn.png");
  pauseImg[0] = loadImage("\\src\\pause.png");
  pauseImg[1] = loadImage("\\src\\play.png");
  resultPageBg = loadImage("\\src\\resultPage.jpg");
  playAgainBtn = loadImage("\\src\\playAgainBtn.png");
  exitBtn = loadImage("\\src\\exitBtn.png");
  for(int i=0;i<numFrames;i++){
    images[i] = loadImage("\\src\\blood"+(i+1)+".png");    
  }
  for(int i=0;i<enemyNum;i++){
    enemy[i] = loadImage("\\src\\enemy"+(i+1)+".png");
  }
  font = createFont("標楷體",16,true); 
  
  sound = 1;
  volume = 1;
  level = 1;
  enemyTime = 50;
  enemySpeed = 5;
  enemyKind = new IntList();
  enemyX = new IntList();
  enemyY = new IntList();
  bulletX = new IntList();
  bulletY = new IntList();
  
}
int x = 299;
int y = 650;
int bgy = 0;
void draw(){
  if(!bgSong.isPlaying() && pause == 0){
    bgSong.cue(0);
    bgSong.play();
  }
  if(page == 0){
    startPage();
  }
  else if(page == 1){
    gamePage();
  }
  else if(page == 2){
    resultPage();
  }
  
}
void keyPressed( ){
  if(page == 1 && pause == 0){
    if(key == 'w'){
      if(y > 0){
        y-=enemySpeed;
      }
    }
    if(key == 's'){
      if(y < 660){
        y+=enemySpeed;
      }
    }
    if(key == 'a'){
      if(x > 0){
        x-=enemySpeed;
      }
    }
    if(key == 'd'){
      if(x < 600){
        x+=enemySpeed;
      }
    }
  }
  
}
void mousePressed( ){
  if(page == 0){
    if(mouseX > 465 && mouseX < 695 && mouseY > 850 && mouseY < 940){
       page = 1;
    }
   
  }
  if(page == 1){
    if(mouseX > 350 && mouseX < 380 && mouseY > 15 && mouseY < 45){
      if(volume == 0){
        bgSong.amp(0.4);
        volume = 1;
      }
      else{
        bgSong.amp(0);
        volume = 0;
      }
    }
    else if(mouseX > 390 && mouseX < 420 && mouseY > 15 && mouseY < 45){
      if(sound == 0){
        shootSound.amp(0.7);
        bombSound.amp(0.5);
        treasureSound.amp(1);
        sound = 1;
      }
      else{
        shootSound.amp(0);
        bombSound.amp(0);
        treasureSound.amp(0);
        sound = 0;
      }
    }
    else if(mouseX > 430 && mouseX < 460 && mouseY > 15 && mouseY < 45){
      if(pause == 0){
        bgSong.pause();
        pause = 1;
      }
      else{
        bgSong.play();
        pause = 0;
      }
    }
    else if(pause == 1 && mouseX > 300 && mouseX < 400 && mouseY > 350 && mouseY < 400){
      bgSong.play();
      pause = 0;
    }
    else if(pause == 1 && mouseX > 300 && mouseX < 400 && mouseY > 450 && mouseY < 500){
      newGame();
    }
    else{
      if(pause == 0){
        bulletX.append(x+43);
        bulletY.append(y);
        bulletNum += 1;
        shootSound.play();
      }
     
    }
   
  }
  if(page == 2){
    if(mouseX > 55 && mouseX < 295 && mouseY > 850 && mouseY < 940){
      newGame();
      page = 1;
    }
    else if(mouseX > 405 && mouseX < 645 && mouseY > 850 && mouseY < 940){
      exit();
    }
  }
  
}

void startPage(){
  image(startPageBg,0,0,710,950);
  image(startBtn,460,850,240,90);
  fill(0);
  textFont(font,20); 
  text("背景音樂:\nAudio Source：Legionnaire by Scott Buckley \nPromoted by : J&B 無版權音樂庫",0,880);
}

void gamePage(){
  background(0);
  image(bg,0,bgy,710,950);
  image(bg2,0,(-949+bgy),710,950);
  if(treasureShow == 0){
    if(bgy < 870){
      treasureTime = bgy + 80;
    }
    else{
      treasureTime = 80 - (950 - bgy) - 1;
    }
    treasureShow = 1;
  }
  else if(treasureShow == 1){
    if(bgy == treasureTime){
      treasureShow = 2;
      treasureX = floor(random(610));
      treasureY = floor(random(850));
    }
  }
  else if(treasureShow == 2){
    image(treasure,treasureX,treasureY,100,100);
  }
  if(bgy % enemyTime == 0){
    enemyX.append(floor(random(630)));
    enemyKind.append(floor(random(2)));
    enemyY.append(-50);
  }
  for(int i=0;i<enemyY.size();i++){
    if(pause == 0){
     enemyY.set(i,enemyY.get(i)+enemySpeed);
    }
    if(enemyY.get(i) > 950){
      enemyX.remove(i);
      enemyKind.remove(i);
      enemyY.remove(i);
    }
    else{
      image(enemy[enemyKind.get(i)],enemyX.get(i),enemyY.get(i),80,80);
    }
    
  }
  for(int i=0;i<bulletX.size();i++){
    if(pause == 0){
      bulletY.set(i,bulletY.get(i)-10);
    }
    if(bulletY.get(i) < -116){
      bulletX.remove(i);
      bulletY.remove(i);
    }
    else{
      image(bullet,bulletX.get(i),bulletY.get(i),20,116);
    }
   
  }
  if(pause == 0){
    bgy++;
  }
  image(spaceShip,x,y,112,300);
  image(images[blood],0,15,300,30);
  fill(255);
  textFont(font,24); 
  text("Score: "+score,550,40);
  text("Level: "+level,550,80);
  image(volumeImg[volume],350,15,30,30);
  image(soundImg[sound],390,15,30,30);
  image(pauseImg[pause],430,15,30,30);
  if(bgy==950){
    bgy=0;
  }
  if(blood == 8){;
    page = 2;
  }
  collision();
  if(pause == 1){
    stroke(205,38,38);
    fill(0);
    rect(100,100,500,750);
    fill(255);
    text("遊戲暫停",300,250);
    stroke(50);
    fill(200);
    rect(300,350,100,50);
    rect(300,450,100,50);
    fill(0);
    text("繼續",327,385);
    text("重新開始",303,485);
  }
}

void resultPage(){
  image(resultPageBg,0,0,710,950);
  image(playAgainBtn,55,850,240,90);
  image(exitBtn,405,850,240,90);
  fill(0);
  textFont(font,36); 
  text(score,180,78);
  text(bulletNum,305,745);
  text(treasureNum,580,745);
}

void collision(){
  if(page == 1){
    if(treasureShow == 2){
      if(treasureX > x - 80 && treasureX < x + 100 && treasureY > y - 80 && treasureY < y + 270){
        treasureSound.play();
        treasureNum += 1;
        treasureShow = 0;
        if(blood > 0){
          blood -= 1;
        }
        else{
          score += 50;
          enemyTimeCount();
          
        }
      }
    }
    
    for(int i=0;i<enemyX.size();i++){
      int j = 0;
      for(j = 0; j < bulletX.size(); j++){
         if(enemyX.get(i) > bulletX.get(j)-70 && enemyX.get(i) < bulletX.get(j)+15 && enemyY.get(i) > bulletY.get(j) - 70 && enemyY.get(i) < bulletY.get(j)){
           bulletX.remove(j);
           bulletY.remove(j);
           enemyX.remove(i);
           enemyY.remove(i);
           enemyKind.remove(i);

           bombSound.play();
           score += 10;
           enemyTimeCount();
           break;
        }
      }
      if(j != bulletX.size()){
        break;
      }
     
    }
    
    for(int i=0;i<enemyX.size();i++){
      if(enemyX.get(i) > x - 50 && enemyX.get(i) < x +100 && enemyY.get(i) > y - 50 && enemyY.get(i) < y + 270){
        if(blood < 8){
          blood++;
          enemyX.remove(i);
          enemyY.remove(i);
          enemyKind.remove(i);

          bombSound.play();
          break;
        }
        
      }
    }
    
  }
  
}

void newGame(){
  enemyKind = new IntList();
  enemyX = new IntList();
  enemyY = new IntList();
  bulletX = new IntList();
  bulletY = new IntList();
  x = 299;
  y = 650;
  bgy = 0;
  treasureShow = 0;
  blood = 0;
  score = 0;
  bulletNum = 0;
  treasureNum = 0;
  bgSong.cue(0);
  bgSong.play();
  pause = 0;
  enemyTime = 50;
  enemySpeed = 5;
  level = 1;
}

void enemyTimeCount(){
  if(score > 0 && score < 50){
    enemyTime = 50;
    enemySpeed = 5;
    level = 1;
  }
  else if(score >= 50 && score < 100){
    enemyTime = 45;
    enemySpeed = 8;
    level = 2;
  }
  else if(score >= 100 && score < 150){
    enemyTime = 40;
    enemySpeed = 10;
    level = 3;
  }
  else if(score >= 150 && score < 200){
    enemyTime = 35;
    enemySpeed = 12;
    level = 4;
  }
  else if(score >= 200 && score < 300){
    enemyTime = 30;
    enemySpeed = 15;
    level = 5;
  }
  else if(score >= 300 && score < 400){
    enemyTime = 25;
    enemySpeed = 17;
    level = 6;
  }
  else if(score >= 400 && score < 600){
    enemyTime = 20;
    enemySpeed = 20;
    level = 7;
  }
  else if(score >= 600 && score < 850){
    enemyTime = 15;
    enemySpeed = 22;
    level = 8;
  }
  else if(score >= 850 && score < 1100){
    enemyTime = 10;
    enemySpeed = 25;
    level = 9;
  }
  else if(score >= 1100){
    enemyTime = 5;
    enemySpeed = 27;
    level = 10;
  }
}
