HashMap<Integer, Boolean> keys;

void setup_keys(){
  keys = new HashMap<Integer, Boolean>();
}

void keyhandling(float dt){
  if (keys.getOrDefault(80, false)){// p key - pause
    PAUSE = !PAUSE;
    keys.put(80, false);
  };
  if (keys.getOrDefault(90, false)){ // z key - zoom in
    zoom *= 1.05; 
    zoom = min(1000, zoom);
  };
  if (keys.getOrDefault(88, false)){// x key - zoom out
    zoom /= 1.05;
    zoom = max(60, zoom);
  };
  if (keys.getOrDefault(83, false)){// s key - steroegraphic
    projection = Projection.Stereo;
    zoom = 100;
  };
  if (keys.getOrDefault(79, false)) {// o key - orthographic
    projection = Projection.Ortho;
    zoom = 250;
  };
  if (keys.getOrDefault(71, false)){// g key - gnomonic
    projection = Projection.Gnomonic;
    zoom = 100;
  };
  if (keys.getOrDefault(69, false)){// e key - earth texture
    texture = Texture.Earth;
  };
  if (keys.getOrDefault(82, false)){// r key - rainbow texture
    texture = Texture.Rainbow;
  };
  //if PAUSE skip movement keys
  if (PAUSE) return;
  //if(keys.getOrDefault(UP, false)) move(movespeed);
  //if(keys.getOrDefault(DOWN, false)) move(-movespeed);
  if (keys.getOrDefault(RIGHT, false)) turn(turnspeed*dt); // turn right
  if (keys.getOrDefault(LEFT, false)) turn(-turnspeed*dt); // turn left
}

void keyPressed(){
  //println(keyCode);
  keys.put(keyCode, true);
  if(keyCode == ENTER){
    restart();
  }
}

void keyReleased(){
  keys.put(keyCode, false);
}
