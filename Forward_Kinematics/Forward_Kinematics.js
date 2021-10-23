let val = 7;
var angles = [];
var rec = 12;
var len;
function setup() {
  createCanvas(1000,560);
  frameRate(144);
  len = createSlider(20,100,60,1);
  len.position(width-140,height+20);
  for(var i = 0;i<val;i++)
  {
     var sli = createSlider(-PI/2,PI/2,0,0.01);
     sli.position(20,height+20+30*i);
     angles.push(sli); 
  }
}


function draw() {
  background(51);
  stroke(5);
  translate(width/2,height - 70);
  textSize(24);
  text('Angles', -width/2+30,50);
  text('Length', width/2-120,50);
  stroke(255);
  fill(222,184,135);
  rect(-20,5,40,200);
  rotate(-PI/2);
  var x = 0,y = 0;
  for(var i = 0;i<val;i++)
  {
    var sum = 0;
    for(var j = 0;j<=i;j++)
    sum+=angles[j].value();
    fill(0,0,0);
    strokeWeight(7);
    line(x,y,x+len.value()*cos(sum),y+len.value()*sin(sum));
    fill(200,0,0);
    strokeWeight(1);
    ellipse(x,y,rec,rec);
    x+=len.value()*cos(sum);
    y+=len.value()*sin(sum);
  }
    ellipse(x,y,rec,rec);
}
