import processing.serial.*; //<>//
import processing.sound.*;

Serial myPort;
SawOsc saw;

SoundFile[] file;

int numsounds = 5;
int state =0;
String comPortChoice;
static String val;
int width=20;
String portName;
float y=360;
float[] octave = {0.25, 0.5, 1.0, 2.0, 4.0};

// The playSound array is defining how many samples will be played at each trigger event
int[] playSound = {1, 1, 1, 1, 1};

// The trigger is an integer number in milliseconds so we can schedule new events in the draw loop
int trigger;

// This array holds the pixel positions of the rectangles which are drawn each event
int[] posx = {0, 128, 256, 384, 512, 640, 768, 896};
void setup()
{
  size (1024, 300, JAVA2D);
  background(0);
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  for (int i=0; i<Serial.list().length; i++) {
    portName = Serial.list()[i];
    println(i+" --> "+portName);
  }
  println("!!!!!!!!!!!!!!!!! ");
  println("Wybierz COM port ");
// while(!keyPressed){
   try {
    myPort = new Serial(this, Serial.list()[7], 9600);
  }
  catch (Exception x) {
    // Print command when exception encountered
    System.out.println("Exception" + x);
  }

  // Create an array of empty soundfiles
  file = new SoundFile[numsounds];
  // Load 5 soundfiles from a folder in a for loop. By naming the files 1., 2., 3., n.aif it is easy to iterate
  // through the folder and load all files in one line of code.
  for (int i = 0; i < numsounds; i++) {
    file[i] = new SoundFile(this, (i+1) + ".aif");
  }
}

void playSmpl(int i) {
  //      // Choose a random color and get set to noStroke()
  fill(int(random(255)), int(random(255)), int(random(255)));
  noStroke();
  float rate;
  try {
    rect(posx[i], 0, 120, 260);
  }

  // catch block to handle the exception
  catch (Exception x) {
    // Print command when exception encountered
    System.out.println("Exception" + x);
  }

  // try block to deal with exception
  try {
    if (i<4) {
      rate = octave[2];
      file[i].play(rate, 1.0);
    } else {
      rate = octave[3];
      file[i-4].play(rate, 1.0);
    }
  }

  // catch block to handle the exception
  catch (Exception x) {
    // Print command when exception encountered
    System.out.println("Exception" + x);
  }
}      
void keyPressed() {
  //  print(key);
  String mval;
  if (key>='0'&& key<='9') {
    String moja=str(key);
    mval=(moja+" pressed");
      String[] msplitval = mval.split("\\s+");
     // println(msplitval[0]);
     // println(msplitval[1]);
      if (msplitval[0]!="null") {
          playSmpl(int(msplitval[0]));
          comPortChoice=msplitval[0];
      }
    }
}
void draw()
{
      if (state==0){
        if(keyPressed){
      comPortChoice=str(key);
      println("Wybrano "+comPortChoice);
//      break;
//    }
 }
    if(comPortChoice!=null){
        state=1;
  //  break;
    try {
    myPort = new Serial(this, Serial.list()[int(comPortChoice)], 9600);
  }
  catch (Exception x) {
    // Print command when exception encountered
    System.out.println("Exception" + x);
  }

    }
    else if (state==1){
  if (myPort!=null) {
    if ( myPort.available() > 0) 
    {  // If data is available,
      val = myPort.readStringUntil('\n');         // read it and store it in val
      if (val!=null) {
        String[] splitval = val.split("\\s+");
        println(splitval[0]);
        println(splitval[1]);
        if (int(splitval[0])>=0 && int(splitval[0])<=12) {
          if (splitval[1].equals("touched")) {
            playSmpl(int(splitval[0]));
          }
        }
      }
    }
  }
    }
}
  
}
