HashMap<Integer, Boolean> keys;

void setup_keys(){
  keys = new HashMap<Integer, Boolean>();
}

void keyhandling(){
  //if(keys.getOrDefault(UP, false)) move(movespeed);
  //if(keys.getOrDefault(DOWN, false)) move(-movespeed);
  if (keys.getOrDefault(RIGHT, false)) turn(turnspeed);
  if (keys.getOrDefault(LEFT, false)) turn(-turnspeed);
  if (keys.getOrDefault(90, false)){ // z key
    zoom *= 1.05; 
    zoom = min(1000, zoom);
  };
  if (keys.getOrDefault(88, false)){// x key 
    zoom /= 1.05;
    zoom = max(60, zoom);
  };
  if (keys.getOrDefault(83, false)){// s key 
    projection = Projection.Stereo;
    zoom = 100;
  };
  if (keys.getOrDefault(79, false)) {// o key
    projection = Projection.Ortho;
    zoom = 250;
  };
  if (keys.getOrDefault(71, false)){// g key 
    projection = Projection.Gnomonic;
    zoom = 100;
  };
  if (keys.getOrDefault(69, false)){// e key 
    texture = Texture.Earth;
  };
  if (keys.getOrDefault(82, false)){// r key 
    texture = Texture.Rainbow;
  };
}

void keyPressed(){
  println(keyCode);
  keys.put(keyCode, true);
  if(keyCode==ENTER){
    restart();
  }
}

void keyReleased(){
  keys.put(keyCode, false);
}
