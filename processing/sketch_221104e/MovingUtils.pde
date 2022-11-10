void swarm(){
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
}

void predatorMovement(){
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
}

void leaderMovement(){
  if (followLeader)
  {
    leader.move ();
    leader.flock (bouncers);
    leader.checkEdges();
    leader.display();
  }
}

void changeSpeed(float speed){
  int n = bouncers.size();  
  for (int i=0; i<n; i++){
    bouncers.get(i).speed = speed;
    bouncers.get(i).SPEED = speed;
  }
}

void hotterSpeed(){
  changeSpeed(8);
}

void turnBackSpeed(){
  changeSpeed(6);
}

void changeBackColor(){
  
}
