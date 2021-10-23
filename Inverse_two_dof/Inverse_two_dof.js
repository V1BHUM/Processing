var a = 200,b = 100;
var A,B;
var off = 300;
var rad = 12;

function setup() {
  createCanvas(800,600);
  A = createSlider(60,180,100,1);
  B = createSlider(70,180,120,1);
  frameRate(60);
}


function draw() {
  background(51);
  stroke(255);
  a = A.value();
  b = B.value();
  
  translate(width/2,height-off);
  strokeWeight(5);
  var c = sqrt((mouseX-width/2)*(mouseX-width/2)+(mouseY+off-height)*(mouseY+off-height));
  var angle = acos((b*b+a*a-c*c)/(2.0*a*b));
  var an = atan(sin(angle)/(a/b-cos(angle)));//map(mouseX,0,width,0,PI);
  if(an<0)
    an+=PI;
  var theta = atan((mouseY-height+off)/(mouseX-width/2));
  if(theta<0)
    theta+=PI;
  if(mouseY-height+off<0)
    theta-=PI;
  an-=theta;
  var x1 = a*cos(an),y1 = -a*sin(an);
  var x2 = x1+b*cos(an+angle-PI),y2 = y1-b*sin(an+angle-PI);
  if((c<=(a+b)))
  {
  stroke(255);
  fill(color(200,20,40));
  strokeWeight(5);
  line(0,0,x1,y1);
  line(x1,y1,x2,y2);
  strokeWeight(1.5);
  ellipse(0,0,rad);
  ellipse(x1,y1,rad);
  ellipse(x2,y2,rad);
  var x3 = c*cos(theta),y3 = c*sin(theta);
  
  strokeWeight(2);
  fill(color(60,200,80,10));
  stroke(color(100,200,100));
  arc(0, 0, 2*(a+b), 2*(a+b), 0, 2*PI, CHORD);
  }
  else
  {
  strokeWeight(2);
  fill(color(200,50,80,30));
  stroke(color(200,20,  30));
  arc(0, 0, 2*(a+b), 2*(a+b), 0, 2*PI, CHORD);    
  }
  //circle(0,0,2*(a+b));
}
