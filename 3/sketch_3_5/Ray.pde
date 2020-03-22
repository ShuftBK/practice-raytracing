// Ray
class Ray{
  Vec origin; // 始点
  Vec dir; // 方向(単位ベクトル)
  
  Ray(Vec origin,Vec dir){
    this.origin = origin;
    this.dir = dir.normalize();
  }
}
