//  for x=z*2^15 the value of y=2^15 * arctan(z) will be computed
int atan32(int x){
    static int i0 = -4070;
    static int i1 = -12483;
    static int i2 =  17009;
    static int i3 = -19;

    int r;
    r = i1+((i0*x)>>15);
    r = i2+((x*(r>>2))>>15);
    r = i3+((x*r)>>15);
  return  r<<1;
}

