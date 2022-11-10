void temperatureReceiver(){
  if (myPort!=null && myPort.available()>0){       
    val = myPort.readString();
    if (val.length() == 2){
      int intVal = Integer.parseInt(val); 
      intVal = 154 + 8*(intVal - 20);
      println(intVal);
      back = color(intVal, intVal, intVal);
    }  
  }
}
