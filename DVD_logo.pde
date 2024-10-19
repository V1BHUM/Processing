import java.math.BigInteger;

float startAngle = radians(45);  // Start angle (in radians)
float speed = 5;     // Speed of movement

float x, y, end_x, end_y;          // Position of the line
float dx, dy;        // Direction of movement

float endpoint_size = 30;
boolean stop_drawing = false;


void setup() {
  //size(700, 492);
  fullScreen();
  strokeWeight(2);
  stop_drawing = false;
  speed = 7;
  background(50);
  int gcd = BigInteger.valueOf(width).gcd(BigInteger.valueOf(height)).intValue();
  int lcm = (width*height)/gcd;
  int x_pair = (int)pow(-1, lcm/width);
  int y_pair = (int)pow(-1, lcm/height);
  end_x = map(x_pair, 1, -1, 0, width);
  end_y = map(y_pair, 1, -1, height, 0);
  
  // Initialize position at bottom-left corner
  x = 0;
  y = height;
  stroke(255);
  fill(204, 255, 153);  // Set the fill color (red)
  ellipse(x, y, endpoint_size, endpoint_size);  // Draw a solid red circle
  fill(255, 102, 0);  // Set the fill color (red)
  ellipse(end_x, end_y, endpoint_size, endpoint_size);  // Draw a solid red circle
  
  // Calculate initial movement direction based on the angle
  dx = 1;
  dy = -1;  // Negating to account for inverted y-axis
}

void draw() {
  for(int i = 0;i<speed & !stop_drawing;i++) {
    // Draw the red line
    stroke(color(255, 0, 0), 220);
    point(x, y);

    // Move the line
    x += dx;
    y += dy;
  
    // Reflect off walls (invert direction)
    if (x <= 0 || x >= width) {
      dx *= -1;
    }
    if (y <= 0 || y >= height) {
      dy *= -1;
    }
    if (x==end_x && y==end_y) {
      stop_drawing=true;
    }
  }
}

// Fast forward by pressing 'F'
void keyPressed() {
  if (key == 'f' || key == 'F') {
    speed += 1;
  }
  if (key == 'r' || key == 'R') {
    setup();
  }
  if (key == 'b' || key == 'B') {
    speed *= 0.9;
  }
  if (speed < 1)
    speed = 0;
}
