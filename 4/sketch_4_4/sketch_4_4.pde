PImage imageTest;

Scene scene = new Scene(); // シーン
Vec eye = new Vec(0,0,4); // 視点

void setup(){
  size(256,256);
    // 画像を読み込む
  imageTest = loadImage("images/icon.png");
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
  Material mtlSphere = new Material(new Spectrum(0.1,0.5,0.9));
  mtlSphere.refractive = 0.9;
  mtlSphere.refractiveIndex = 1.5;
  scene.addIntersectable(new Sphere(new Vec(0,0,0),1,mtlSphere));

  // チェック柄の床
  Material mtlFloor1 = new Material(new Spectrum(0.5,0.5,0.5));
  Material mtlFloor2 = new Material(new Spectrum(0.2,0.2,0.2));
  scene.addIntersectable(new CheckedObj(new Plane(new Vec(0,-1,0),new Vec(0,1,0),mtlFloor1),1,mtlFloor2));

  // 壁
  Material mtlWall1 = new Material(new Spectrum(0.5, 0.5, 0.5));
  scene.addIntersectable(new TexturedObj(
    new Plane(
      new Vec(0, 0, -5), // 位置
      new Vec(0, 0, 1), // 法線
      mtlWall1 // 材質1
    ),
    imageTest, // 画像
    10, // テクスチャの大きさ
    new Vec(-5, -5, 0), // テクスチャ原点
    new Vec(1, 0, 0), // テクスチャu方向
    new Vec(0, 1, 0) // テクスチャv方向
  ));

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
