// 交差していないことを示す値
final float NO_HIT = Float.POSITIVE_INFINITY;

void setup(){
  size(256,256);
}

int y = 0;
Vec eye = new Vec(0,0,5);
Vec sphereCenter = new Vec(0,0,0);
float sphereRadius = 1;

Vec lightPos = new Vec(10,10,10); // 点光源の位置
float lightPower = 4000; // 点光源のパワー

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
  
  // 球との交差判定を行い，視点からの距離を取得する
  float t = intersectRaySphere(eye,rayDir,sphereCenter,sphereRadius);
  
  // 球と交差しなかった場合は，黒を返して終了
  if (t == NO_HIT)
    return color(0,0,0);
    
  // 視点からの距離を使って交差座標を計算する
  Vec p = eye.add(rayDir.scale(t));
  
  // 交差した球の票目苑の法線ベクトルを計算する
  Vec n = p.sub(sphereCenter).normalize();
  
  // 光源計算を行う
  float brightness = diffuseLighting(p, n, lightPos, lightPower);
  
  // 明るさからピクセルの色に変換する
  int i = min(int(brightness * 255), 255);
  return color(i, i, i);
}

Vec calcPrimaryRay(int x,int y){
  float imagePlane = height;

  float dx = x + 0.5 - width /2;
  float dy = -(y + 0.5 - height / 2);
  float dz = -imagePlane;
  
  return new Vec(dx,dy,dz).normalize();
}

// レイとの交差判定
// 交差した点までの距離を返す．交差しなかった場合はNO_HITを返す．
float intersectRaySphere(Vec rayOrigin,Vec rayDir,Vec sphereCenter,float sphereRadius){
  Vec v = rayOrigin.sub(sphereCenter);
  float b = rayDir.dot(v);
  float c = v.dot(v) - sq(sphereRadius);
  // 交差判定の方程式の判別式
  float d = b * b -c;
  
  if ( 0 <= d){// 交差した場合
    // 交点までの距離を計算する
    float s = sqrt(d);
    float t = -b - s;
    if (t <= 0)
      t = -b + s;
    if(0 < t)
      return t;
  }
  // 交差していなことを示すNO_HITを返す
  return NO_HIT;
}

// 拡散反射面の光源計算
float diffuseLighting(Vec p, Vec n, Vec lightPos, float lightPower){
  // 交点から光源に向かうベクトル
  Vec v = lightPos.sub(p);
  Vec l = v.normalize();
  
  // 法線との内積でベクトル同士の向きを調べる
  float dot = n.dot(l);
  
  if (dot > 0){ // 面が光源方向を向いている：ライティング
    // 光源からの影響を計算する
    float r = v.len();
    return lightPower * dot / (4 * PI * r * r);
  } else { // 面が光源方向を向いていない：光が当たらない
    // 光源からの影響がない
    return 0;
  }
}
