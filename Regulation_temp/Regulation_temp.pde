import processing.serial.*;
Serial ArduinoSeriePort;
PFont font12;
PFont font18;
PFont font50;
PImage temp_serre;
float temp = 46;
float[] tempHistory = new float[101];
int mercure = 0;
Boolean NouvelleMesure = false;


void setup(){
  size(1000,500);
  temp_serre = loadImage("InterfaceTh1000x500.gif");
  
  font12 = loadFont("Verdana-12.vlw");
  font18 = loadFont("Verdana-18.vlw");
  font50 = loadFont("Verdana-50.vlw");
  
  println(Serial.list());
  String NomPort =Serial.list()[1];
  println("Connexion avec "+NomPort);
  ArduinoSeriePort = new Serial(this, NomPort, 9600);

}
void draw(){
  background(temp_serre);

  textFont(font50);
  textAlign(LEFT,BOTTOM);
  fill(70);
  text(tempHistory[99],240,70);
  graduation();
  mercure();
  graph();
  courbe();
  
  
}
void graduation(){
  strokeWeight(1);

  for(byte i = 0; i <= 100; i++){
    if(i%10 == 0){
      stroke(255,0,0);
      line(65,380 - 3*i,75, 380 - 3*i);
      fill(70);
      textFont(font12);
      textAlign(CENTER,BOTTOM);
      text(i, 50, 385-3*i);
     }
     else{
       stroke(0);
       line(70,380 - 3*i,75, 380 - 3*i);
     }
  }
  
}

void mercure(){
  mercure = (int(tempHistory[99])*300)/100;
  fill(192,0,0);
  stroke(192,0,0);
  rect(96,380,20,-mercure);
  rect(96,400,20,-19);
}
void graph(){
  fill(253,253,150);
  stroke(0);
  strokeWeight(2);
  rect(240,120,700,300);

  strokeWeight(1);
  for(byte x = 0;x <=100; x++){
    if(x%10 == 0){
      stroke(150);
      line(240 + 7 *x, 418,240 + 7*x, 121);
      
      fill(70);
      textFont(font12);
      textAlign(CENTER,BOTTOM);
      text(x, 240 +7*x, 440);
    }
    else{
      stroke(200);
      line(240 + 7 *x, 418,240 + 7*x, 121);
    }
    
  }
  
  for(byte y = 0; y <= 100; y++){
    if(y%10 == 0){
      stroke(150);
      line(241,420-3*y,938, 420-3*y);
      fill(70);
      textFont(font18);
      textAlign(CENTER,BOTTOM);
      text(y, 215,  430-3*y);
    }
  }

}
void courbe(){
  stroke(0);
  for(byte i =0; i <=100; i++){
    line(240+7*i,420-((tempHistory[i]*300)/100), 240+7*i+1, 420-((tempHistory[i+1]*300)/100));
  }
  
}
void serialEvent(Serial ArduinoSeriePort){
  String SerialDataStr = ArduinoSeriePort.readStringUntil('\n');
  if(SerialDataStr != null){
    temp = float(SerialDataStr);
    for(int i=0; i<100;i++){
      tempHistory[i] = tempHistory[i+1];
    }
    tempHistory[100] = temp;
    NouvelleMesure = true;
   }
}
