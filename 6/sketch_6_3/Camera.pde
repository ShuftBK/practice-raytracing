// カメラ
class Camera{
    Vec eye, origin, xaxis, yaxis;

    // 視点からある位置を向くように設定を行う
    void lookAt(Vec eye,Vec target,Vec up,float fov,int width,int height){
        this.eye = eye;
        float imagePlane = (height / 2) / tan(fov / 2);
        Vec v = target.sub(eye).normalize();
        xaxis = v.cross(up).normalize();
        yaxis = v.cross(xaxis);
        Vec center = v.scale(imagePlane);
        this.origin = center.sub(xaxis.scale(0.5 * width)).sub(yaxis.scale(0.5 * height));
    }

    // スクリーン座標に対する一次レイを返す
    Ray ray(float x,float y){
        Vec p = origin.add(xaxis.scale(x)).add(yaxis.scale(y));
        Vec dir = p.normalize();
        return new Ray(eye,dir);
    }
}