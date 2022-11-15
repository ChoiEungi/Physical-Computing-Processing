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

float[] sc = {255, 255, 255};
float[] ec = {0, 0, 0};
float[][] color_to_show = new float[60][3];

void setup_mv_arr(){
  for (int i = 0; i < 3; i++){
    float c = sc[i];
    for(int j=0; j<60; j++){
      color_to_show[j][i] = c;
      c += (ec[i]-sc[i] / 60);
    }
  }
}

int flag = -1;
int c_idx =  0;

void change_to_bright(){
  int TO_WHITE_FLAG = 1;
  background(color_to_show[c_idx][0], color_to_show[c_idx][1], color_to_show[c_idx][2]);
  if (c_idx==0 && flag ==TO_WHITE_FLAG) flag = 0;
  if (flag == TO_WHITE_FLAG) c_idx--;
}

void change_to_dark(){
  int TO_DARK_FLAG = 2;
  background(color_to_show[c_idx][0], color_to_show[c_idx][1], color_to_show[c_idx][2]);
  if (c_idx ==59 && flag==TO_DARK_FLAG) flag = 0;
  if (flag == TO_DARK_FLAG) c_idx++;
  }