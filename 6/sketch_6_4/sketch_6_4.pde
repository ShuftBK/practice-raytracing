Camera camera = new Camera();

Scene scene = new Scene(); // シーン
Vec eye = new Vec(0,0,7); // 視点

// サンプル数
final int SAMPLES = 100;

void setup(){
  size(256,256);
  initScene();
  initCamera();
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
  // 空の色
  scene.setSkyColor(new Spectrum(0.7,0.75,0.8));
  
  // 球
  Material mtl1 = new Material(new Spectrum(0.7,0.3,0.9));
  scene.addIntersectable(new Sphere(new Vec(-2.2,0,0),1,mtl1));
  Material mtl2 = new Material(new Spectrum(0.9,0.7,0.3));
  mtl2.reflective = 0.8;
  scene.addIntersectable(new Sphere(new Vec(   0,0,0),1,mtl2));
  Material mtl3 = new Material(new Spectrum(0.3,0.9,0.7));
  mtl3.refractive = 0.8;
  mtl3.refractiveIndex = 1.5;
  scene.addIntersectable(new Sphere(new Vec( 2.2,0,0),1,mtl3));

  // 光源
  Material mtlLight = new Material(new Spectrum(0.0,0.0,0.0));
  mtlLight.emissive = new Spectrum(30.0,20.0,10.0);
  scene.addIntersectable(new Sphere(
    new Vec(0,4.0,0),
    1,
    mtlLight
  ));

  // チェック柄の床
  Material mtlFloor1 = new Material(new Spectrum(0.9,0.9,0.9));
  Material mtlFloor2 = new Material(new Spectrum(0.4,0.4,0.4));
  scene.addIntersectable(new CheckedObj(new Plane(new Vec(0,-1,0),new Vec(0,1,0),mtlFloor1),1,mtlFloor2));

}

// カメラの設定
void initCamera(){
  camera.lookAt(
    new Vec(0.0,0.0,9.0), // 視点
    new Vec(0.0,0.0,0.0), // 注視点
    new Vec(0.0,1.0,0.0), // 上方向
    radians(40.0), // 視野角
    width,
    height
  );
}

// 一次レイを計算
Ray calcPrimaryRay(int x,int y){
  // カメラを用いて一次レイを求める
  return camera.ray(
    x + random(-0.5,0.5),
    y + random(-0.5,0.5)
  );
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
