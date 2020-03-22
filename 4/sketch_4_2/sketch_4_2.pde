Scene scene = new Scene(); // シーン
Vec eye = new Vec(0,0,7); // 視点

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
  // 球を3つシーンに追加する
  scene.addIntersectable(new Sphere(new Vec(-2,0,0), 0.8, new Material(new Spectrum(0.9,0.1,0.5))));
  scene.addIntersectable(new Sphere(new Vec( 0,0,0), 0.8, new Material(new Spectrum(0.1,0.9,0.5))));
  scene.addIntersectable(new Sphere(new Vec( 2,0,0), 0.8, new Material(new Spectrum(0.1,0.5,0.9))));
  
  // 床をシーンに追加する
  scene.addIntersectable(new Plane(new Vec(0,-0.8,0), new Vec(0,1,0), new Material(new Spectrum(0.8,0.8,0.8))));
  
  // 点光源を2つシーンに追加する
  scene.addLight(new Light(new Vec( 100,100,100),new Spectrum(400000,100000,400000)));
  scene.addLight(new Light(new Vec(-100,100,100),new Spectrum(100000,400000,100000)));
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
  Spectrum l = scene.trace(ray);
  return l.toColor();
}
