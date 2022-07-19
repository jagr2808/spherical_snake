void turn(float angle){
  PVector newright = new PVector();
  PVector temp = new PVector();
  PVector newforward = new PVector();
  
  PVector.mult(right, cos(angle), newright);
  PVector.mult(forward, sin(angle), temp);
  newright.add(temp);
  
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
  PVector newright = new PVector();
  PVector temp = new PVector();
  PVector newforward = new PVector();
  
  PVector.mult(forward, cos(angle), newright);
  PVector.mult(head, sin(angle), temp);
  newright.add(temp);
  
  PVector.mult(head, cos(angle), newforward);
  PVector.mult(forward, -sin(angle), temp);
  newforward.add(temp);
  
  head = newforward;
  forward = newright;
  forward.normalize();
  head.normalize();
  right = forward.cross(head);
  right.normalize();
}

void pull(PVector p, PVector goal, float dist){
  if (dist > p.dist(goal)) return;
  PVector diff = goal.copy();
  diff.sub(p);
  diff.normalize();
  diff.mult(p.dist(goal) - dist);
  p.add(diff);
  p.normalize();
}
