float noiseX, noiseY;
ArrayList<Osc> oscs;
//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;
int index;
float r1, r2, g1, g2, b1, b2;
int[] r1s = {0, 255, 0};
int[] r2s = {255, 255, 13};
int[] g1s = {139, 238, 8};
int[] g2s = {20, 0, 255};
int[] b1s = {139, 0, 255};
int[] b2s = {147, 0, 0};

void setup(){
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)

  size(500, 500);
  smooth();
  frameRate(30);

  index = 0;   
  noiseX = random(100);
  noiseY = random(100);
  oscs = new ArrayList<Osc>();
  for(int x = 0; x <= 500; x += 25){
    for(int y = 0; y <= 500; y += 25){
      oscs.add(new Osc(new PVector(x, y)));
    }
  }
}
 
void draw(){
  background(0);
  for(Osc osc: oscs){
    osc.display();
  } 
}
 
class Osc{
  PVector pos;
  float rad;
   
  Osc(PVector pos){
    this.pos = pos;
    rad = random(TWO_PI);
  }
   
  void display(){
    float diameter = map(sin(rad), -1, 1, 10, 24);
    noStroke();
    fill(map(sin(rad), -1, 1, r1s[index], r2s[index]), map(sin(rad), -1, 1, g1s[index], g2s[index]), map(sin(rad), -1, 1, b1s[index], b2s[index]));
    ellipse(pos.x, pos.y, diameter, diameter);
    rad += map(noise(noiseX + pos.x * 0.05, noiseY + pos.y * 0.05), 0, 1, PI / 128, PI / 6);
    if(rad > TWO_PI){
      rad -= TWO_PI;
    }
  }
   
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
     if(theOscMessage.checkTypetag("f")) { // looking for 5 parameters
        float receivedX = theOscMessage.get(0).floatValue();
        index = (int)receivedX - 1;
        
       // println("Received new output values from Wekinator");  
      } else {
        println("Error: unexpected OSC message received by Processing: ");
        theOscMessage.print();
      }
 }
}

void sendOscNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setOutputNames");
  msg.add("one"); //Now send all 5 names
  oscP5.send(msg, dest);
}