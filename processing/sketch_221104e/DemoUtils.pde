
void gather_left(){
  GPIO.noInterrupts();
  bewegungsModus = 2;
  flag = 1;
  
  thread("delay_spread");
  //if(millis() > time+delay) bewegungsModus = 3; 
}

void delay_spread(){
  delay(8000);
  bewegungsModus = 3;
  thread("delay_radial");
}

void delay_radial(){
  delay(10000);
  bewegungsModus = 4;
  thread("back_to_origin");
}

void back_to_origin(){
  delay(10000);
  bewegungsModus = 5;
  // turn off interrupt
}
