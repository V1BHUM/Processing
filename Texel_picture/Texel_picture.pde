import processing.video.*;

Capture cam;

int segment = 10;

String brightness_array = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,^`'. ";
color background = color(51);

float calculateBrightness(color c) {
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  
  // Use the weighted formula to calculate perceived brightness
  return (0.299 * r + 0.587 * g + 0.114 * b);
}

class Texel {
 int x, y, h;
 color col;
 
 Texel(int x, int y, int h) {
  this.x = x;
  this.y = y;
  this.h = h;
  this.col = color(255);
 }
 
 void place() {
  fill(this.col);
  textSize(this.h);
  char ch = brightness_array.charAt((int)map(calculateBrightness(this.col), 255, 0, 0, brightness_array.length()-1));
  text(ch, this.x, this.y+this.h);
 }
 
 void updateCol(color[] pix) {
  int r = 0, g = 0, b = 0, total = 0;
  for(int x = max(0, this.x); x<min(width, this.x + this.h); x++) {
    for(int y = max(0, this.y); y<min(height, this.y + this.h); y++) {
      int idx = x + y*width;
      total++;
      r += red(pix[idx]);
      g += green(pix[idx]);
      b += blue(pix[idx]);
    }
  }
  this.col = color(r/total, g/total, b/total);
 }
}

ArrayList<Texel> grid;

void placeGrid() {
 grid = new ArrayList<>();
 
 for (int x = 0;x<width/segment;x++) {
    for (int y = 0;y<width/segment;y++) {
      grid.add(new Texel(x*segment, y*segment, segment));
    }
  }
}
  

void setup() {
 size(700, 700);
 String[] cameras = Capture.list(); // List available cameras
  
 if (cameras.length == 0) {
    println("No cameras found.");
    exit();
 } 
 else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + ": " + cameras[i]);
  }
 }
 // Initialize the camera (0 is the default, can change to another index if needed)
 cam = new Capture(this, width, height, cameras[0]);
 cam.start();
 placeGrid();
}


void draw() {
 if (cam.available()) 
      cam.read(); // Read the image from the camera
 cam.loadPixels(); 
 background(20);
 
 for (Texel t: grid) {   
   t.updateCol(cam.pixels);
   t.place(); 
 }
}

void keyPressed() {
 if(key == 'f' || key == 'F') {
  segment += 3;
  placeGrid();
 }
 if(key == 'b' || key == 'B') {
  segment -= 3;
  if (segment < 3)
    segment = 3;
  placeGrid();
 }
}
