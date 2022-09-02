PVector head, forward, right, apple;

ArrayList<PVector> snake, apples;

float zoom;

float movespeed = 1.1;
float turnspeed = 2*movespeed;
int snakeresolution = 7;
float colisiondist = 0.2; // collision distance
float pulldist = colisiondist / snakeresolution; // distance between joints

boolean shadow = true;

int score = 0;

int oldtime = 0;
boolean GAMEOVER = false;
boolean PAUSE = false;

PImage head_img;
PImage img;
enum Texture {
  Rainbow,
  Earth
}
Texture texture = Texture.Earth;

enum Projection {
  Stereo,
  Ortho,
  Gnomonic,
  StaticMercator,
  DynamicMercator
}
Projection projection = Projection.Stereo;

void restart(){
  GAMEOVER = false;
  PAUSE = false;
  head = new PVector(0, 0, 1);
  forward = new PVector(0, 1, 0);
  right = new PVector(1, 0, 0);
  
  score = 0;
  apple = PVector.random3D();
  
  snake = new ArrayList<PVector>();
  for(int i=0; i < 15*snakeresolution; i++) snake.add(new PVector(0,1,1));
}

void setup(){
  fullScreen();
  //size(800, 600);
  zoom = height / 16;
  background(0);
  img = loadImage("earth.png");
  img.loadPixels();
  head_img = loadImage("head.png");
  
  setup_keys();
  setup_triangles();
  
  restart();
}

void draw(){
  int newtime = millis();
  float dt = float(newtime - oldtime) / 1000;
  oldtime = newtime;
  
  render();
  update(dt);
}

void render(){
  if(GAMEOVER){
    background(0);
    fill(255);
    textSize(30);
    text(String.format("%7s%s", "",
    "Your score was " + score + "\nPress Enter to play again"), width/2 - 160, height/2);
    return;
  }
  
  draw_background();
  
  //draw triangulation of sphere
  noStroke();
  for(int i=0; i < triang.size(); i++){
    PVector q = PVector.add(triang.get(i)[0], triang.get(i)[1]).add(triang.get(i)[2]).normalize();
    fill(spherePixel(q));
    beginShape();
    for(PVector p : triang.get(i)){
      PVector v = draw_point(p);
      if (v.z > 0) vertex(v.x, v.y);
    }
    endShape();
  }
  
  PVector v;
 
  v = draw_point(apple); 
  if (v.z > 0) fill(250, 0, 0);
  else fill(250, 0, 0, 30); //apple is transparent when on the opposite side of sphere
  ellipse(v.x, v.y, colisiondist*zoom, colisiondist*zoom);
  
  
  v = draw_point(snake.get(0)); 
  PVector w = draw_point(head);
  stroke(segmentColor(0));
  strokeWeight(colisiondist*zoom);
  if(abs(v.x-w.x) < 3*zoom) line(v.x, v.y, w.x, w.y);
  noStroke();
  fill(segmentColor(0));
  circle(v.x, v.y, colisiondist*zoom);
  
  for (int i = snake.size()-1; i > 0; i--){
    v = draw_point(snake.get(i)); 
    fill(segmentColor(float(i)/snakeresolution));
    if (true) {
      w = draw_point(snake.get(i-1));
      stroke(segmentColor(float(i)/snakeresolution), v.z > 0 ? 255 : shadow ? 15 : 0);
      strokeWeight(colisiondist*zoom*exp(-2.5*pow(float(i)/(snake.size()), 4)));
      if(abs(v.x-w.x) < 3*zoom) line(v.x, v.y, w.x, w.y);
      noStroke();
      //circle(v.x, v.y, dist*zoom*exp(-i));
    }
  }
  
  //draw snake head
  v = draw_point(head); 
  w = draw_point(snake.get(0));
  pushMatrix();
  PImage resize_img = head_img.copy();
  resize_img.resize(int(2.3*colisiondist*zoom), int(2.3*colisiondist*zoom));
   
  translate(v.x, v.y);
  rotate(atan2(v.y-w.y, v.x-w.x) + PI/2);
  image(resize_img, -resize_img.width/2, -resize_img.height/2);
  popMatrix();
  
  textSize(28);
  if(projection == Projection.Ortho) fill(255);
  else fill(15);
  text("Score: " + score, 10, 30);
}

void update(float dt){
  keyhandling(dt);
  if(PAUSE){
    //draw pause icon
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(width - 60, 20, 10, 40);
    rect(width - 40, 20, 10, 40);
    return;
  }
  
  move(movespeed*dt);
  
  if(apple.dist(head) < colisiondist*0.85){
    apple = PVector.random3D();
    for (int i = 0; i < snakeresolution; i++) snake.add(snake.get(snake.size()-1).copy());
    score += 10;
  }
  
  
  pull(snake.get(0), head, colisiondist);
  for (int i = 1; i < snake.size(); i++){
    if(i > snakeresolution && snake.get(i).dist(head) < colisiondist*0.85){ 
      GAMEOVER = true;
      return;
    }
    if (!PAUSE) pull(snake.get(i), snake.get(i-1), pulldist);
  }
}
