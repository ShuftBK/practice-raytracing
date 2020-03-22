// 無限平面
class Plane implements Intersectable{
  Vec n; // 面法線(a,b,c)
  float d; // 原点からの距離(平面の方程式ax+by+cz+d=0)
  Material material; // マテリアル
  
  // 面法線n, 点pを通る平面
  Plane(Vec p,Vec n,Material material){
    this.n = n.normalize();
    this.d = -p.dot(this.n);
    this.material = material;
  }
  
  Intersection intersect(Ray ray){
    Intersection isect = new Intersection();
    float v = this.n.dot(ray.dir);
    float t = -(this.n.dot(ray.origin) + this.d) / v;
    if(0 < t){
      isect.t = t;
      isect.p = ray.origin.add(ray.dir.scale(t));
      isect.n = this.n;
      isect.material = this.material;
    }
    return isect;
  }
}
