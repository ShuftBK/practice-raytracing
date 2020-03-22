void setup(){
  size(256,256);
}

int y = 0;

color calcPixelColor(int x, int y){
  return color(x,y,0);
}

void draw(){
  for (int x = 0; x < width; x++){
    color c = calcPixelColor(x,y);
    set(x,y,c);
  }
  y++;
  if (height <= y){
    noLoop();
  }
}
