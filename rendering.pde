PVector draw_point(PVector p){
  switch(projection) {
      case Stereo:
        return draw_point_stereographic(p);
      case Ortho:
         return draw_point_orth(p);
      case Gnomonic:
        return draw_point_gnomonic(p);
    }
    return null;
}

void draw_background(){
  switch(projection) {
      case Ortho:
         background(0);
         fill(255, 255, 255);
         //ellipse(width/2, height/2, 2*zoom, 2*zoom);
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
  PVector proj = head.copy();
  proj.mult(-p.dot(head));
  proj.add(p);
  proj.mult(1/p.dot(head));
  
  int x = int(zoom * proj.dot(right) + width/2);
  int y = int(zoom * proj.dot(forward) + height/2);
  int z = 0;
  
  if(p.dot(head) > 0){
    z = 1;
  }else{
    z = -1;
  }
  
  return new PVector(x, y, z);
}

PVector draw_point_stereographic(PVector p){
  PVector proj = head.copy();
  proj.add(p);
  proj.mult(2/proj.dot(head));
  
  int x = int(zoom * proj.dot(right) + width/2);
  int y = int(zoom * proj.dot(forward) + height/2);
  int z = 0;
  
  if(p.dot(head) > -0.91){
    z = 1;
  }else{
    z = -1;
  }
  
  return new PVector(x, y, z);
}
