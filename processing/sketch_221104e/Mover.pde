class Mover
{
  PVector direction;

  float speed;
  float SPEED;

  float noiseScale;
  float noiseStrength;
  float forceStrength;

  Fish f;

  Mover () // Konstruktor = setup der Mover Klasse
  {
    setRandomValues();
  }

  Mover (float x, float y) // Konstruktor = setup der Mover Klasse
  {
    setRandomValues ();
    f.setHead (new PVector (x, y));
    f.resetBody();
  }

  // SET ---------------------------

  void setRandomValues ()
  {
    f = new Fish (random (width), random (height));
    f.ellipseSize = random (10, 20);

    float angle = random (TWO_PI);
    direction = new PVector (cos (angle), sin (angle));

    speed = random (5.5, 8);
    SPEED = speed;
    noiseScale = 80;
    noiseStrength = 1;
    forceStrength = random (0.1, 0.2);
  }

  void setColor (color c)
  {
    f.setColor (c);
  }

  void setColor (color c1, color c2)
  {
    f.setColor (c1, c2);
  }

  void setFishSize (float s)
  {
    f.ellipseSize = s;
  }

  // GET --------------------------------

  float getSize ()
  {
    return f.getSize();
  }

  PVector getLocation ()
  {
    return f.getHead();
  }

  // GENEREL ------------------------------

  void update ()
  {
    update (0);
  }

  void update (int mode)
  {
    if (mode == 0) // bouncing ball
    {
      speed = SPEED * 0.7;
      move();
      checkEdgesAndBounce();
    } 
    else if (mode == 1) // noise
    {
      speed = SPEED * 0.7;
      addNoise ();
      move();
      checkEdgesAndRelocate ();
    }
    else if (mode == 2) // steer
    {
      // steer (mouseX, mouseY);
      steer (X_SIZE/2, Y_SIZE/2);
      move();
    }
    else if (mode == 3) // seek
    {
      speed = SPEED * 0.7;
      // seek (mouseX, mouseY);
      seek (X_SIZE/2, Y_SIZE/2);
      move();
    }
    else // radial
    {
      speed = SPEED * 0.7;
      addRadial ();
      move();
      checkEdges();
    }

    display();
  }

  // FLOCK ------------------------------

  void flock (ArrayList <Mover> boids)
  {
    PVector location = f.getHead();

    PVector other;
    float otherSize ;

    PVector cohesionSum = new PVector (0, 0);
    float cohesionCount = 0;

    PVector seperationSum = new PVector (0, 0);
    float seperationCount = 0;

    PVector alignSum = new PVector (0, 0);
    float speedSum = 0;
    float alignCount = 0;

    for (int i = 0; i < boids.size(); i++)
    {
      other = boids.get(i).f.getHead();
      otherSize = boids.get(i).f.getSize();

      float distance = PVector.dist (other, location);
 

      if (distance > 0 && distance <70) //align + cohesion
      {
        cohesionSum.add (other);
        cohesionCount++;

        alignSum.add (boids.get(i).direction);
        speedSum += boids.get(i).speed;
        alignCount++;
      }

     if (distance > 0 && distance < (f.getSize()+otherSize)*1.2) // seperate bei collision
      {
        float angle = atan2 (location.y-other.y, location.x-other.x);

        seperationSum.add (cos (angle), sin (angle), 0);
        seperationCount++;
      }

      if (alignCount > 10 || seperationCount > 10) break;
    }

    // cohesion: bewege dich in die Mitte deiner Nachbarn
    // seperation: renne nicht in andere hinein
    // align: bewege dich in die Richtung deiner Nachbarn

    if (cohesionCount > 0)
    {
      cohesionSum.div (cohesionCount);
      cohesion (cohesionSum, 1);
    }

    if (alignCount > 0)
    {
      speedSum /= alignCount;
      alignSum.div (alignCount);
      align (alignSum, speedSum, 1.3);
    }

    if (seperationCount > 0)
    {
      seperationSum.div (seperationCount);
      seperation (seperationSum, 2);
    }
  }

  void cohesion (PVector force, float strength)
  {
    steer (force.x, force.y, strength);
  }

  void seperation (PVector force, float strength)
  {
    force.limit (strength*forceStrength);

    direction.add (force);
    direction.normalize();

    speed *= 1.1;
    speed = constrain (speed, 0, SPEED * 1.5);
  }

  void align (PVector force, float forceSpeed, float strength)
  {
    speed = lerp (speed, forceSpeed, strength*forceStrength);

    force.normalize();
    force.mult (strength*forceStrength);

    direction.add (force);
    direction.normalize();
  }

  // HOW TO MOVE ----------------------------

  void steer (float x, float y)
  {
    steer (x, y, 1);
  }

  void steer (float x, float y, float strength)
  {
    PVector location = f.getHead();

    float angle = atan2 (y-location.y, x -location.x);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength * strength);

    direction.add (force);
    direction.normalize();

    float currentDistance = dist (x, y, location.x, location.y);

    if (currentDistance < 70)
    {
      speed = map (currentDistance, 0, 70, 0, SPEED);
    }
    else speed = SPEED;
  }

  void seek (float x, float y)
  {
    seek (x, y, 1);
  }

  void seek (float x, float y, float strength)
  {
    PVector location = f.getHead();

    float angle = atan2 (y-location.y, x -location.x);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength * strength);

    direction.add (force);
    direction.normalize();
  }
  
  void addRadial ()
  {
    PVector location = f.getHead();
    
    float m = noise (frameCount / (2*noiseScale));
    m = map (m,0, 1, - 1.2, 1.2);
    
    float maxDistance = m * dist (0, 0, width/2, height/2);
    float distance = dist (location.x, location.y, width/2, height/2);
    
    float angle = map (distance, 0, maxDistance, 0, TWO_PI);
    
    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength);
    
    direction.add (force);
    direction.normalize();
  }

  void addNoise ()
  {
    PVector location = f.getHead();

    float noiseValue = noise (location.x /noiseScale, location.y / noiseScale, frameCount / noiseScale);
    noiseValue*= TWO_PI * noiseStrength;

    PVector force = new PVector (cos (noiseValue), sin (noiseValue));
    //Processing 2.0:
    //PVector force = PVector.fromAngle (noiseValue);
    force.mult (forceStrength);
    direction.add (force);
    direction.normalize();
  }

  // MOVE ----------------------------------------- 

  void move ()
  {
    PVector location = f.getHead();

    PVector velocity = direction.get();
    velocity.mult (speed);
    location.add (velocity);

    f.setHead (location);
  }

  // CHECK --------------------------------------------------------

  void checkEdgesAndRelocate ()
  {
    PVector location = f.getTail();
    float diameter = f.getSize();

    if (location.x < -diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);

      f.setHead (location);
      f.resetBody ();
    } 
    else if (location.x > width+diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);

      f.setHead (location);
      f.resetBody ();
    }

    if (location.y < -diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
      f.setHead (location);
      f.resetBody ();
    } 
    else if (location.y > height + diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
      f.setHead (location);
      f.resetBody ();
    }
  }


  void checkEdges ()
  {
    PVector location = f.getTail();
    float diameter = f.getSize();

    if (location.x < -diameter / 2)
    {
      location.x = width+diameter /2;
      f.setHead (location);
    } 
    else if (location.x > width+diameter /2)
    {
      location.x = -diameter /2;
      f.setHead (location);
    }

    if (location.y < -diameter /2)
    {
      location.y = height+diameter /2;
      f.setHead (location);
    } 
    else if (location.y > height+diameter /2)
    {
      location.y = -diameter /2;
      f.setHead (location);
    }
  }

  void checkEdgesAndBounce ()
  {
    PVector location = f.getHead();
    float radius = f.getSize() / 2;

    if (location.x < radius )
    {
      location.x = radius ;
      f.setHead (location);
      direction.x = direction.x * -1;
    } 
    else if (location.x > width-radius )
    {
      location.x = width-radius ;
      f.setHead (location);
      direction.x *= -1;
    }

    if (location.y < radius )
    {
      location.y = radius ;
      f.setHead (location);
      direction.y *= -1;
    } 
    else if (location.y > height-radius )
    {
      location.y = height-radius ;
      f.setHead (location);
      direction.y *= -1;
    }
  }

  // DISPLAY ---------------------------------------------------------------

  void display ()
  {
    f.display();
  }
}
