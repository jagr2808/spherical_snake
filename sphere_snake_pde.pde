PVector head, forward, right, apple;

ArrayList<PVector> snake, apples;

float zoom = 100;

float movespeed = 0.02;
float turnspeed = 0.04;

enum Projection {
  Stereo,
  Ortho,
  Gnomonic
}
Projection projection = Projection.Stereo;

void restart(){
  head = new PVector(0, 0, 1);
  forward = new PVector(0, 1, 0);
  right = new PVector(1, 0, 0);
  
  apple = PVector.random3D();
  
  snake = new ArrayList<PVector>();
  for(int i=0; i < 15; i++) snake.add(new PVector(0,1,1));
}

void setup(){
  size(600, 600);
  background(0);
  
  setup_keys();
  setup_triangles();
  
  restart();
}

void draw(){
  draw_background();
  move(movespeed);
  
  noStroke();
  for(int i=0; i < triang.size(); i++){
    randomSeed(i);
    PVector q = triang.get(i)[0];
    fill(256*(0.5*q.x + 0.5),256*(0.5*q.y + 0.5),265*(0.5*q.z + 0.5));
    beginShape();
    for(PVector p : triang.get(i)){
      PVector v = draw_point(p);
      if (v.z > 0) vertex(v.x, v.y);
    }
    endShape();
  }
  
  float dist = 0.2;
  PVector v;
  
  if(apple.dist(head) < dist*0.85){
    apple = PVector.random3D();
    snake.add(snake.get(snake.size()-1).copy());
  }
  
  v = draw_point(apple); 
  if (v.z > 0) fill(250, 0, 0);
  else fill(250, 0, 0, 30);
  ellipse(v.x, v.y, dist*zoom, dist*zoom);
  
  v = draw_point(head); 
  fill(0, 220, 0);
  ellipse(v.x, v.y, dist*zoom, dist*zoom);
  
  pull(snake.get(0), head, dist);
  
  v = draw_point(snake.get(0)); 
  fill(0, 210, 0);
  ellipse(v.x, v.y, dist*zoom, dist*zoom);
  
  for (int i = 1; i < snake.size(); i++){
    if(snake.get(i).dist(head) < dist*0.85){ 
      restart();
      return;
    }
    pull(snake.get(i), snake.get(i-1), dist);
    v = draw_point(snake.get(i)); 
    fill(0, max(210-10*i, 100+50*sin(i*PI/11)), 0);
    if (v.z > 0) ellipse(v.x, v.y, dist*zoom, dist*zoom);
  }
  
  keyhandling();
}
