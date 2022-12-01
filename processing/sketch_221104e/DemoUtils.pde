

boolean thread_lock=false;

void gather_left(){
  
  if (thread_lock==false){
    bewegungsModus = 2;
    flag = 1;
    thread_lock = true;   
    thread("delay_spread");
  } 
}

void delay_spread(){
  delay(8000);
  flag=2;
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
  thread_lock=false;
  unlcok_sound();
  // turn off interrupt
}
