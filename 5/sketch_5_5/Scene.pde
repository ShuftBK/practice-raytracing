// シーン
final Spectrum COLOR_SKY = new Spectrum(0.7,0.7,0.7);
final int DEPTH_MAX = 10; // トレースの最大回数
final float VACUUM_REFRACTIVE_INDEX = 1.0; // 真空の屈折率

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
  Spectrum trace(Ray ray,int depth){
    // トレースの最大回数に達した場合は計算を中断する
    if (DEPTH_MAX < depth)
      return BLACK;
    
    // 交点を求める
    Intersection isect = findNearestIntersection(ray);

    // 物体と交差しなかった場合は空の色を返す
    if (!isect.hit())
      return COLOR_SKY;

    Material m = isect.material;

    // 反射方向を求め反射レイを飛ばす
    Vec r = isect.n.randomHemisphere();
    Spectrum li = trace(new Ray(isect.p,r), depth + 1);

    // 計算結果への影響度合いを計算する
    Spectrum fr = m.diffuse.scale(1.0 / PI);
    float factor = 2.0 * PI * isect.n.dot(r);
    Spectrum l = li.mul(fr).scale(factor);

    return l;
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
      if(visible(p,lightPos)){
        float r = v.len();
        float factor = dot / (4 * PI * r * r);
        return lightPower.scale(factor).mul(diffuseColor);
      }
    }
    return BLACK;
  }

  boolean visible(Vec org, Vec target){
    Vec v = target.sub(org).normalize();
    // シャドウレイを求める
    Ray shadowRay = new Ray(org, v);
    for (int i = 0;i < this.objList.size();i++){
      Intersectable obj = this.objList.get(i);
      // 交差が判明した時点で処理を打ち切る
      if(obj.intersect(shadowRay).t < v.len())
        return false;
    }
    // シーン中のどの物体ともシャドウレイが交差しない場合にのみtrueを返す
    return true;
  }
}
