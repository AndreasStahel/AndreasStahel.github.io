#include <octave/oct.h>

DEFUN_DLD (VolterraLotkaC, args, ,
  "Function for a Volterra Lotka model")
{
  ColumnVector dx (2);
  ColumnVector x (args(1).vector_value ());

  double c1=1.0, c2=2.0, c3=1.0, c4=1.0;

  dx(0) = (c1-c2*x(1))*x(0);
  dx(1) = (c3*x(0)-c4)*x(1);

  return octave_value (dx);
}
