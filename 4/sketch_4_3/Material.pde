// マテリアル
class Material{
  Spectrum diffuse; // 物体の拡散反射色
  float reflective = 0; // 鏡面反射率
  
  Material(Spectrum diffuse){
    this.diffuse = diffuse;
  }
}
