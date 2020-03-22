// チェック柄の物体
class CheckedObj implements Intersectable {
    Intersectable obj; // 物体の形状・マテリアルその1
    float gridWidth; // グリッドの幅
    Material material2; // マテリアルその2

    CheckedObj(Intersectable obj,float gridWidth,Material material2){
        this.obj = obj;
        this.gridWidth = gridWidth;
        this.material2 = material2;
    }

    Intersection intersect(Ray ray){
        Intersection isect = obj.intersect(ray);

        if (isect.hit()){
            int i = (round(isect.p.x/this.gridWidth)+
                    round(isect.p.y/this.gridWidth)+
                    round(isect.p.z/this.gridWidth));
            if (i % 2 == 0)
                isect.material = this.material2;
        }
        return isect;
    }
}