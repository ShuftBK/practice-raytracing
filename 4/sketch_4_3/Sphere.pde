// 球
class Sphere implements Intersectable{
  Vec center; // 中心座標
  float radius; // 半径
  Material material; // マテリアル
  
  Sphere(Vec center,float radius,Material material){
    this.center = center;
    this.radius = radius;
    this.material = material;
  }
  
  Intersection intersect(Ray ray){
    Intersection isect = new Intersection();
    Vec v = ray.origin.sub(this.center);
    float b = ray.dir.dot(v);
    float c = v.dot(v) - sq(this.radius);
    float d = b * b - c;
    if(d >= 0){
      float s = sqrt(d);
      float t = -b - s;
      if(t <= 0)
        t = -b + s;
      if(0 < t){
        isect.t = t;
        isect.p = ray.origin.add(ray.dir.scale(t));
        isect.n = isect.p.sub(this.center).normalize();
        isect.material = this.material;
      }
    }
    return isect;
  }
}
