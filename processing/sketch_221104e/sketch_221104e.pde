import processing.serial.*;

/*----------------------------------
       
 Copyright by Diana Lange 2014
 Don't use without any permission. Creative Commons: Attribution Non-Commercial.
       
 mail: kontakt@diana-lange.de
 web: diana-lange.de
 facebook: https://www.facebook.com/DianaLangeDesign
 flickr: http://www.flickr.com/photos/dianalange/collections/
 tumblr: http://dianalange.tumblr.com/
 twitter: http://twitter.com/DianaOnTheRoad
 vimeo: https://vimeo.com/dianalange/videos
      
 -----------------------------------*/


ArrayList <Mover> bouncers;

Mover predator;
Mover leader;
int predatorvictim = 0;

boolean followLeader = false;
boolean hidefromPredator = false;

int bewegungsModus = 5;
// 0 = BOUNCE
// 1 = NOISE
// 2 = STEER: 
// 3 = SEEK  cohension specific point
// 4 = RADIAL
// 5 = FLOCK

int X_SIZE;
int Y_SIZE;
void setup ()
{

  X_SIZE = displayWidth/2;
  Y_SIZE = displayHeight;
  fullScreen();
  
  //setupSerial();
  setup_mv_arr();


  bouncers = new ArrayList ();
  predator = new Mover ();
  predator.setColor (#52A59D, #ffffff);
  predator.setFishSize (15);
  predator.speed = 6;
  predator.SPEED = 6;

  leader = new Mover();
  leader.setColor (#ffffff, #666666);
  leader.setFishSize (15);
  leader.speed = 6;
  leader.SPEED = 6;

  for (int i = 0; i < 180; i++)
  {
    Mover newMover = new Mover();
    bouncers.add (newMover);
  }
  frameRate (30);

}

Serial myPort; // create object from Serial class
String val; // data rec'd from the Serial port
void setupSerial(){
  printArray(Serial.list());
  String[] serialArray = Serial.list();
  if (serialArray.length > 1 && serialArray[1].equals("COM6")){
    myPort = new Serial(this, serialArray[1], 9600); // COM6 
  }
}

color back = #e9e9e9; //e9 is same with 233
void draw ()
{
  background (back);
  change_to_dark();
  change_to_bright();

  temperatureReceiver();
  
  swarm();

  // PREDATOR MOVEMENT ---------------------
  predatorMovement();

  // LEADER  MOVEMENT ---------------------
  leaderMovement();
}


void keyPressed ()
{
  if ( key == 'l') followLeader = !followLeader;
  if ( key == 'p') hidefromPredator = !hidefromPredator;
  if (key == ' ')
  {
    bewegungsModus++;
    if (bewegungsModus > 5) bewegungsModus = 0;
  }
  if (key=='1') {
    // hotterSpeed();
    bewegungsModus = 2;
    flag = 1;
  }
    
  if (key=='0') {
    turnBackSpeed();
    bewegungsModus = 3;
    flag = 2;
  }
} 
