#include <DFRobot_DHT11.h>
DFRobot_DHT11 DHT;
#define DHT11_PIN 2
#define SOUND_PIN 3

void setup(){
  Serial.begin(9600);
  pinMode(SOUND_PIN, INPUT);
}


void loop(){
  receiveSerialCommunication();
  soundSerialCommunication();
  tempSerialCommunication();
}

int temperature=0;
void tempSerialCommunication(){
  DHT.read(DHT11_PIN);
  Serial.print(temperature);
  Serial.println(DHT.temperature);

  if (temperature < DHT.temperature){
    Serial.println("Hot");
  }

  temperature = DHT.temperature;
  delay(5000); 
}

void soundSerialCommunication(){
  if (digitalRead(SOUND_PIN) == HIGH) {
    // Serial.println(analogRead(SOUND_PIN));
  }
}

void receiveSerialCommunication(){
  if(Serial.available()){
    // Serial.print(num);
  }
}
