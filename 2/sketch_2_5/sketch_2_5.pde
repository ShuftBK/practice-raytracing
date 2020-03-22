 void setup(){
  size(256,256);
}

int y = 0;

Vec eye = new Vec(0,0,5);
Vec sphereCenter = new Vec(0,0,0);
float sphereRadius = 1;

void draw(){
  for(int x = 0;x < width;x++){
    color c = calcPixelColor(x,y);
    set(x,y,c);
  }
  
  y++;
  if (height <= y){
    noLoop();
  }
}

color calcPixelColor(int x,int y){
  // calculate primary ray direction
  Vec rayDir = calcPrimaryRay(x,y);
  
  if (intersectRaySphere(eye,rayDir,sphereCenter,sphereRadius)){
    return color(255,255,255);
  }else{
    return color(0,0,0);
  }
}

Vec calcPrimaryRay(int x,int y){
  float imagePlane = height;

  float dx = x + 0.5 - width /2;
  float dy = -(y + 0.5 - height / 2);
  float dz = -imagePlane;
  
  return new Vec(dx,dy,dz).normalize();
}

boolean intersectRaySphere(Vec rayOrigin,Vec rayDir,Vec sphereCenter,float sphereRadius){
  Vec v = rayOrigin.sub(sphereCenter);
  float b = rayDir.dot(v);
  float c = v.dot(v) - sq(sphereRadius);
  float d = b * b -c;
  return d >= 0;
}
