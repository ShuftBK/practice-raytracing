final int NUM = 1000; // 試行回数
int sum = 0; // 原点までの距離が1以下だった点の数

void setup(){
    size(256,256);

    for (int i = 0;i < NUM;i++){
        // ランダムに点のい位置を決定する
        float x = random(0.0, 1.0);
        float y = random(0.0, 1.0);
    
        // 点と原点との距離が1以下だったらsumを1増やす
        float l = sqrt(x * x + y * y);
        if (l <= 1.0){
            sum++;
        }
    }

    // 円周率を出力
    println(4.0*sum/NUM);
}