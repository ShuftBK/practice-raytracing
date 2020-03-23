Scene scene = new Scene(); // シーン
Vec eye = new Vec(0,0,7); // 視点

// サンプル数
final int SAMPLES = 100;

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
  scene.addIntersectable(new Sphere(new Vec(-2.2,0,0),1,new Material(new Spectrum(0.7,0.3,0.9))));
  scene.addIntersectable(new Sphere(new Vec(   0,0,0),1,new Material(new Spectrum(0.9,0.7,0.3))));
  scene.addIntersectable(new Sphere(new Vec( 2.2,0,0),1,new Material(new Spectrum(0.3,0.9,0.7))));

  // 無限平面
  Material mtlFloor = new Material(new Spectrum(0.9,0.9,0.9));
  scene.addIntersectable(new Plane(new Vec(0,-1,0),new Vec(0,1,0),mtlFloor));
}

// 一次レイを計算
Ray calcPrimaryRay(int x,int y){
  float imagePlane = height;
  
  float dx = x + random(0.0,1.0) - width / 2;
  float dy = -(y + random(0.0,1.0) - height / 2);
  float dz = -imagePlane;
  
  return new Ray(eye, new Vec(dx, dy, dz).normalize());
}

// ピクセルの色を計算
color calcPixelColor(int x,int y){
  // sumに計算結果の和を格納する
  Spectrum sum = BLACK;
  
  for (int i = 0;i < SAMPLES;i++){
    // レイを飛ばし計算結果をsumに足す
    Ray ray = calcPrimaryRay(x,y);
    sum = sum.add(scene.trace(ray,0));
  }

  // sumをサンプル数で割り計算結果の平均を求める
  return sum.scale(1.0 / SAMPLES).toColor();
}
