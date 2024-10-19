import processing.video.*;

int res = 2;
float strokeWt = 0;

Capture cam;
boolean laid_circles = false;

class Circle {
  int x, y, r;
  color col;
    
  int sq_dist(Circle a, Circle b) {
    int x_comp = (a.x - b.x); 
    int y_comp = (a.y - b.y);
    return x_comp * x_comp + y_comp * y_comp;
  }

  Circle(int x, int y, int r) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.col = color(51);
  }

  void grow() {
    this.r += 1;
  }

  boolean intersects(ArrayList<Circle> circles) {
    for (Circle c: circles){
      if ((c != this) & (sq_dist(this, c) <= pow(this.r + c.r, 2) + 10))
        return true;
    }
    return false;
  }
  
  void updateColor(color[] pix) {
   int totalR = 0;
   int totalG = 0;
   int totalB = 0;
   int cnt = 0;
   
   for (int x = max(0, this.x-this.r); x<=min(width-1, this.x+this.r); x++) { 
        for (int y = max(0, this.y-this.r); y<=min(height-1, this.y+this.r); y++) { 
            int dist = (x-this.x)*(x-this.x) + (y-this.y)*(y-this.y);
            int idx = x + y * width;
            if (dist <= this.r) {
                totalR += red(pix[idx]);
                totalG += green(pix[idx]);
                totalB += blue(pix[idx]);
                cnt++;
            }
              
        }
   }
  int avgR = totalR / cnt;
  int avgG = totalG / cnt;
  int avgB = totalB / cnt;
  
  // Return the average color
  this.col = color(avgR, avgG, avgB);
  }
}

ArrayList<Circle> circles;

void setup() {
  size(900, 900); // Set the window size
  String[] cameras = Capture.list(); // List available cameras

  if (cameras.length == 0) {
    println("No cameras found.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + ": " + cameras[i]);
    }

    // Initialize the camera (0 is the default, can change to another index if needed)
    cam = new Capture(this, width, height, cameras[0]);
    cam.start();
  }

  // Initialize the circles list
  circles = new ArrayList<Circle>();
  
  // Create and add circles to the list
  for (int i = 0; i < res; i++) {
    circles.add(new Circle((int)random(0, width), (int)random(0, height), 1));
  }
  stroke(255);
  strokeWeight(strokeWt);
}

void draw() {
  background(51);

  
  if (cam.available()) {
    cam.read(); // Read the image from the camera
  }
  cam.loadPixels();
  loadPixels();
  
  if (!laid_circles) {
    int deltas = 0;
    for (Circle c : circles) {
      if (!c.intersects(circles)) {
        deltas++;
        c.grow();
      }
    }
    if (deltas == 0) 
      laid_circles = true;
  }
  for (Circle c: circles) {
    fill(c.col);
    circle(c.x, c.y, 2*c.r);
    c.updateColor(cam.pixels);
  }
}


void reset() {
  // Initialize the circles list
  circles = new ArrayList<Circle>();
  
  // Create and add circles to the list
  for (int i = 0; i < res; i++) {
    circles.add(new Circle((int)random(0, width), (int)random(0, height), 1));
  }
  laid_circles = false; 
}


void keyPressed() {
 if (key == 'r' || key == 'R') {
    reset();
 }
 if (key == 'f' || key == 'F') {
    res *= 10;     
    reset();
 }
 
 if (key == 'b' || key == 'B') {
    res /= 10;
    if (res <= 2)
      res = 2;
    reset();
 }
}

color invertColor(color c) {
  float r = 255 - red(c);   // Invert red
  float g = 255 - green(c); // Invert green
  float b = 255 - blue(c);  // Invert blue
  return color(r, g, b);    // Return the inverted color
}
