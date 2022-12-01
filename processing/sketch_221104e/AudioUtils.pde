import processing.sound.*;

AudioIn input;
Amplitude loudness;

int MINIMUM_SOUND = 200;
boolean soundLock = false;

void audioUtils(){ 
  float volume = loudness.analyze();
  int volumeSize = int(map(volume, 0, 0.5, 1, 350));
  println(volumeSize);

  if (volumeSize > MINIMUM_SOUND  && soundLock == false){
    println(volumeSize);
    soundLock=true;
    gather_left();
  }
}

void unlcok_sound(){
  soundLock=false;
}
