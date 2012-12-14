import processing.video.*;

Capture cam;
String position;
int lastMillis = 0;
int millisThreshold = 2000;

int[] frontCoord = {380,360};
int[] backCoord = {500,360};

int tripHeight = 50;
int tripWidth = 90;

PImage front;

int listLength = 5;

PImage[] frontList = new PImage[listLength];
//PImage[] backList;
// trying to do occlusion detection in processing

void setup() {
  size(1280, 720);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }
  
  for(int i=0; i<frontList.length; i++) {
    frontList[i] = createImage(tripWidth,tripHeight,RGB);
  }
  front = createImage(tripWidth,tripHeight,RGB);
}


void push(PImage image, PImage[] imageList) {
  for(int i=imageList.length-1; i>1;i--) {
    imageList[i].copy(imageList[i-1],0,0,tripWidth,tripHeight,0,0,tripWidth,tripHeight);
  }
  imageList[0].copy(image,0,0,tripWidth,tripHeight,0,0,tripWidth,tripHeight);
}

void draw() {
  int m = millis();
  // every few seconds, grab two images 
  if (millis() - lastMillis > millisThreshold) {
    front.copy(cam,frontCoord[0],frontCoord[1],tripWidth,tripHeight,0,0,tripWidth,tripHeight);
    //back = image(backCoords);
    push(front,frontList);
    //push(back,backList);
    lastMillis=millis();
  }
  
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  
  // draw all images in the imagelist
  for(int i=0; i<frontList.length; i++) {
    set(i*tripWidth,0,frontList[i]);
  }

  fill(0, 102, 153);
  textSize(32);
  position=mouseX+","+mouseY;
  text(position, 10, tripHeight*2); 
}

