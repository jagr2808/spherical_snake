ArrayList<PVector[]> triang;
int subdivisions = 4;

void setup_triangles(){
 triang = new ArrayList<PVector[]>();
 for(int x = -1; x <= 1; x += 2)
   for(int y = -1; y <= 1; y += 2)
     for(int z = -1; z <= 1; z += 2)
       triang.add(new PVector[]{new PVector(x, 0, 0), new PVector(0, y, 0), new PVector(0, 0, z)}); 
 
 for(int i=0; i < subdivisions; i++){
   triang = subdivide(triang);
 }
}

ArrayList<PVector[]> subdivide(ArrayList<PVector[]> triangulation){
  ArrayList<PVector[]> new_triangulation = new ArrayList<PVector[]>();
  for(PVector[] tri : triangulation){
    PVector m0 = PVector.add(tri[1], tri[2]);
    m0.normalize();
    PVector m1 = PVector.add(tri[0], tri[2]);
    m1.normalize();
    PVector m2 = PVector.add(tri[1], tri[0]);
    m2.normalize();
    new_triangulation.add(new PVector[]{
      tri[0], m2, m1
    });
    new_triangulation.add(new PVector[]{
      m2, tri[1], m0
    });
    new_triangulation.add(new PVector[]{
      m1, m0, tri[2]
    });
    new_triangulation.add(new PVector[]{
      m0, m1, m2
    });
  }
  return new_triangulation;
}
