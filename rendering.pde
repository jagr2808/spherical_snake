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

color spherePixel(PVector q){
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
      int y = int((img.height-1)*(q.z + 1)/2);
      int loc = x + y*img.width;
      r = int(red(img.pixels[loc]));
      g = int(green(img.pixels[loc]));
      b = int(blue(img.pixels[loc]));
      return color(r, g, b);
  }
  return 0;
}
