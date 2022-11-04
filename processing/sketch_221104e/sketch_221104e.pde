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
Serial myPort; // create object from Serial class
String val; // data rec'd from the Serial port

ArrayList <Mover> bouncers;

Mover predator;
Mover leader;
int predatorvictim = 0;

boolean followLeader = true;
boolean hidefromPredator = true;

int bewegungsModus = 5;
// 0 = BOUNCE
// 1 = NOISE
// 2 = STEER
// 3 = SEEK
// 4 = RADIAL
// 5 = FLOCK

void setup ()
{
  myPort = new Serial(this,"COM6", 9600);

  size (600, 400);

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

void distancePrint(){               // Here's where my code is to get the distance, via Serial, and will insert the code to make this the
  if (myPort.available()>0){       
   val = myPort.readString();
   if (val.length() == 2){
    int intVal = Integer.parseInt(val); 
   }  
  }
  // float mapVal = map(intVal, 0, 255, 0, height);
  // println(mapVal);
}

color back = #e9e9e9;
void draw ()
{
  background (back);
  if (myPort.available()>0){       
   val = myPort.readString();
   if (val.length() == 2){
    int intVal = Integer.parseInt(val); 
    intVal = 154 + 8*(intVal - 20);
    println(intVal);
    back = color(intVal, intVal, intVal);
   }  
  }


  // SCHWARM -----------

  for (int i = 0; i < bouncers.size (); i++)
  {
    Mover m = bouncers.get (i);

    if (bewegungsModus != 5) m.update (bewegungsModus);
    else
    {
      m.flock (bouncers);
      m.move();
      m.checkEdges();
      m.display();

      // SWARM PREDATOR REACTION -----------------------

      if (hidefromPredator)
      {
        float distance = dist (predator.getLocation().x, predator.getLocation().y, m.getLocation().x, m.getLocation().y);

        if (distance < predator.getSize() * 3)
        {
          float angle = atan2 (m.getLocation().y-predator.getLocation().y, m.getLocation().x-predator.getLocation().x);

          m.seperation (new PVector (cos (angle), sin (angle)), 5);
        }
      }

      // SWARM LEADER REACTION ---------------------------

      if (followLeader)
      {
        float distance = dist (leader.getLocation().x, leader.getLocation().y, m.getLocation().x, m.getLocation().y);

        if (distance <  70)
        {
          m.steer (leader.getLocation().x, leader.getLocation().y, 1);
        }
      }
    }
  }

  // PREDATOR MOVEMENT ---------------------

  if (hidefromPredator)
  {
    predator.move ();
    PVector target = bouncers.get(predatorvictim).getLocation();
    predator.steer (target.x, target.y);
    predator.checkEdges ();
    predator.display();

    if (PVector.dist (bouncers.get(predatorvictim).getLocation(), predator.getLocation()) < predator.getSize() * 5)
    {
      predatorvictim = (int) random (bouncers.size());
    }
  }

  // LEADER  MOVEMENT ---------------------
  if (followLeader)
  {
    leader.move ();
    leader.flock (bouncers);
    leader.checkEdges();
    leader.display();
  }
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
} 
