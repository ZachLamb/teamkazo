//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;
float val1, val2, val3, val4;

void setup(){
  size(200, 100);
  oscP5 = new OscP5(this,5555); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)

}

void draw(){
  stroke(0);
  textAlign(LEFT, TOP); 
  fill(0);
  text("Receiving OSC messages from\n MusePlayer on port 5555, \nforwarding them to Wekinator \non port 6448", 2, 2);
}
 
//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/muse/eeg")==true) { 
    if(theOscMessage.checkTypetag("ffff")) { // looking for 4 parameters
        float received1 = theOscMessage.get(0).floatValue();
        float received2 = theOscMessage.get(1).floatValue();
        float received3 = theOscMessage.get(2).floatValue();
        float received4 = theOscMessage.get(3).floatValue();
        val1 = received1;
        val2 = received1;
        val3 = received1;
        val4 = received1;
        forwardOscMsg();
        
       // println("Received new output values from Wekinator");  
      } else {
        println("Error: unexpected OSC message received by Processing: ");
        theOscMessage.print();
      }
 }
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
     if(theOscMessage.checkTypetag("f")) { 
        float receivedX = theOscMessage.get(0).floatValue();
        
       // println("Received new output values from Wekinator");  
      } else {
        println("Error: unexpected OSC message received by Processing: ");
        theOscMessage.print();
      }
 }
}

void forwardOscMsg() {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add(val1);
  msg.add(val2);
  msg.add(val3);
  msg.add(val4);
  oscP5.send(msg, dest);
}