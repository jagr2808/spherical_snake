void turn(float angle){
  PVector newright = new PVector();
  PVector temp = new PVector();
  PVector newforward = new PVector();
  
  //rotate "right" towards "forward"
  PVector.mult(right, cos(angle), newright);
  PVector.mult(forward, sin(angle), temp);
  newright.add(temp);
  
  //rotate "forward" away from "right"
  PVector.mult(forward, cos(angle), newforward);
  PVector.mult(right, -sin(angle), temp);
  newforward.add(temp);
  
  forward = newforward;
  right = newright;
  forward.normalize();
  right.normalize();
  head = right.cross(forward);
  head.normalize();
}

void move(float angle){
  PVector newforward = new PVector();
  PVector temp = new PVector();
  PVector newhead = new PVector();
  
  //rotate "head" towards "forward"
  PVector.mult(forward, cos(angle), newforward);
  PVector.mult(head, sin(angle), temp);
  newforward.add(temp);
  
  //rotate "forward" away from "head"
  PVector.mult(head, cos(angle), newhead);
  PVector.mult(forward, -sin(angle), temp);
  newhead.add(temp);
  
  head = newhead;
  forward = newforward;
  forward.normalize();
  head.normalize();
  right = forward.cross(head);
  right.normalize();
}

void pull(PVector p, PVector goal, float dist){
  // move p dist towards goal
  if (dist > p.dist(goal)) return;
  PVector diff = goal.copy();
  diff.sub(p);
  diff.normalize();
  diff.mult(p.dist(goal) - dist);
  p.add(diff);
  p.normalize();
}
