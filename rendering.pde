PVector draw_point(PVector p){
  switch(projection) {
      case Stereo:
        return draw_point_stereographic(p);
      case Ortho:
         return draw_point_orth(p);
      case Gnomonic:
        return draw_point_gnomonic(p);
      case DynamicMercator:
        return draw_point_mercator(p, head, right, forward);
      case StaticMercator:
        return draw_point_mercator(p, new PVector(1,0,0), new PVector(0,1,0), new PVector(0,0,1));
    }
    return null;
}

void draw_background(){
  switch(projection) {
      case Ortho:
         background(0);
         break;
      default:
         background(255);
    }
}

PVector draw_point_orth(PVector p){
  int x = int(zoom * p.dot(right) + width/2);
  int y = int(zoom * p.dot(forward) + height/2);
  int z = 0;
  
  if(p.dot(head) > 0){
    z = 1;
  }else{
    z = -1;
  }
  
  return new PVector(x, y, z);
}

PVector draw_point_gnomonic(PVector p){
  // proj = p/(p*head) - head
  PVector proj = head.copy();
  proj.mult(-p.dot(head));
  proj.add(p);
  proj.mult(1/p.dot(head));
  
  int z;
  if(p.dot(head) > 0){
    z = 1;
  }else{
    z = -1;
  }
  
  int x = int(zoom * proj.dot(right)*z + width/2);
  int y = int(zoom * proj.dot(forward)*z + height/2);
  
  return new PVector(x, y, z);
}

PVector draw_point_stereographic(PVector p){
  // proj = 2(head + p)/(head*(head + p))
  PVector proj = head.copy();
  proj.add(p);
  proj.mult(2/proj.dot(head));
  
  int x = int(zoom * proj.dot(right) + width/2);
  int y = int(zoom * proj.dot(forward) + height/2);
  int z = 0;
  
  if(p.dot(head) > -0.99){
    z = 1;
  }else{
    z = -1;
  }
  
  return new PVector(x, y, z);
}

PVector draw_point_mercator(PVector p, PVector xref, PVector yref, PVector zref){
  float xx = p.dot(xref);
  float yy = p.dot(yref);
  float zz = p.dot(zref);
  float angle = atan2(yy, xx);
  int x = int(zoom*angle);
  int y = int(zoom*zz/(sqrt(1-zz*zz)));
  return new PVector(
  x + width/2, 
  y + height/2, 
  PI - abs(angle) < 0.1 || abs(zz) > 0.99 ? -1:1);
}

color spherePixel(PVector q){
  // given point on sphere returns color
  int r,g,b;
  switch(texture){
    case Rainbow:
      r = int(256*(0.5*q.x + 0.5));
      b = int(256*(0.5*q.y + 0.5));
      g = int(265*(0.5*q.z + 0.5));
      return color(r, g, b);
    case Earth:
      float angle = atan2(q.y, q.x);
      int x = int((img.width -1)*(angle + PI) / (2*PI));
      int y = constrain(int((img.height)*(q.z/(sqrt(1-q.z*q.z)*2) + 1)/2), 0, img.height-2);
      int loc = x + y*img.width;
      r = int(red(img.pixels[loc]));
      g = int(green(img.pixels[loc]));
      b = int(blue(img.pixels[loc]));
      return color(r, g, b);
  }
  return 0;
}

color segmentColor(float i){
  // returns color of the ith segment of the snake
  return color(0, max(210-10*i, 100+50*sin(i*PI/11)), 0);
}
