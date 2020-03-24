// マテリアル
class Material{
  Spectrum diffuse; // 物体の拡散反射色
  float reflective = 0; // 鏡面反射率
  float refractive = 0; // 屈折割合
  float refractiveIndex = 1; // 屈折率
  Spectrum emissive = BLACK; // 発光色(0以上)
  
  Material(Spectrum diffuse){
    this.diffuse = diffuse;
  }
}
