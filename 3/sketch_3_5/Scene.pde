// シーン
class Scene{
  // シーン内の物体・光源を格納するArrayListを定義
  ArrayList<Intersectable> objList = new ArrayList<Intersectable>();
  ArrayList<Light> lightList = new ArrayList<Light>();
  
  Scene(){}
  
  // 形状の追加
  void addIntersectable(Intersectable obj){
    this.objList.add(obj);
  }
  
  // 光源の追加
  void addLight(Light light){
    this.lightList.add(light);
  }
  
  // レイを撃って色をもとめる
  Spectrum trace(Ray ray){
    Intersection isect = findNearestIntersection(ray);
    if (!isect.hit())
      return BLACK;
    return lighting(isect.p,isect.n,isect.material);
  }
  
  // 一番近くの交点をもとめる
  Intersection findNearestIntersection(Ray ray){
    Intersection isect = new Intersection();
    for(int i = 0;i < this.objList.size();i++){
      Intersectable obj = this.objList.get(i);
      Intersection tisect = obj.intersect(ray);
      if(tisect.t < isect.t)
        isect = tisect;
    }
    return isect;
  }
  
  // 光源計算を行う
  Spectrum lighting(Vec p,Vec n,Material m){
    Spectrum L = BLACK;
    for(int i = 0;i < this.lightList.size();i++){
      Light light = this.lightList.get(i);
      Spectrum c = diffuseLighting(p,n,m.diffuse,light.pos,light.power);
      L = L.add(c);
    }
    return L;
  }
  
  // 拡散反射面の光源計算
  Spectrum diffuseLighting(Vec p,Vec n,Spectrum diffuseColor,Vec lightPos,Spectrum lightPower){
    Vec v = lightPos.sub(p);
    Vec l = v.normalize();
    float dot = n.dot(l);
    if (dot > 0){
      float r = v.len();
      float factor = dot / (4 * PI * r * r);
      return lightPower.scale(factor).mul(diffuseColor);
    } else {
      return BLACK;
    }
  }
}
