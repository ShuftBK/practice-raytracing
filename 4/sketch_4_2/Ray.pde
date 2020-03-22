// Ray

// レイを少しだけ進ませる微小距離
final float EPSILON = 0.001;

class Ray{
  Vec origin; // 始点
  Vec dir; // 方向(単位ベクトル)
  
  Ray(Vec origin,Vec dir){
    this.dir = dir.normalize();
    // レイの始点をEPSILONだけ進める
    this.origin = origin.add(this.dir.scale(EPSILON));
  }
}
