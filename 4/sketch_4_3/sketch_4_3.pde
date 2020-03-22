Scene scene = new Scene(); // シーン
Vec eye = new Vec(0,0,4); // 視点

void setup(){
  size(256,256);
  initScene();
}

int y = 0;

void draw(){
  for (int x = 0;x < width;x++){
    color c = calcPixelColor(x,y);
    set(x,y,c);
  }
  y++;
  if(height <= y){
    noLoop();
  }
}

// シーン構築
void initScene(){
  // 球
  Material mtlSpehre = new Material(new Spectrum(0.9,0.5,0.1));
  mtlSpehre.reflective = 0.6;
  scene.addIntersectable(new Sphere(new Vec(0,0,0),1,mtlSpehre));

  // チェック柄の床
  Material mtlFloor1 = new Material(new Spectrum(0.5,0.5,0.5));
  Material mtlFloor2 = new Material(new Spectrum(0.2,0.2,0.2));
  scene.addIntersectable(new CheckedObj(new Plane(new Vec(0,-1,0),new Vec(0,1,0),mtlFloor1),1,mtlFloor2));


  // 点光源
  scene.addLight(new Light(new Vec(100,100,100),new Spectrum(800000,800000,800000)));
}

// 一次レイを計算
Ray calcPrimaryRay(int x,int y){
  float imagePlane = height;
  
  float dx = x + 0.5 - width / 2;
  float dy = -(y + 0.5 - height / 2);
  float dz = -imagePlane;
  
  return new Ray(eye, new Vec(dx, dy, dz).normalize());
}

// ピクセルの色を計算
color calcPixelColor(int x,int y){
  Ray ray = calcPrimaryRay(x,y);
  Spectrum l = scene.trace(ray,0);
  return l.toColor();
}
