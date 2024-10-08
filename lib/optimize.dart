import 'package:ml_linalg/linalg.dart';
import 'normalize.dart';

class Optimize {
  var GP;
  var SP;
  var v;
  Normalize ns = Normalize();
  Normalize ng = Normalize();

  Optimize(this.GP, this.SP);

  void solve() {
    var SP_n = ns.norm(SP);
    var GP_n = ng.norm(GP);

    var x = GP_n[0];
    var y = GP_n[1];
    var xp = SP_n[0];
    var yp = SP_n[1];

    var Ax = Matrix.fromList([
      [x.pow(2).sum(), (x * y).sum(), x.sum()],
      [x.sum(), y.sum(), 1],
      [(x * y).sum(), y.pow(2).sum(), y.sum()]
    ], dtype: DType.float64);

    var Ay = Matrix.fromList([
      [x.pow(2).sum(), (x * y).sum(), x.sum()],
      [(x * y).sum(), y.pow(2).sum(), y.sum()],
      [x.sum(), y.sum(), 1]
    ], dtype: DType.float64);

    var Bx = Matrix.fromList([
      [(xp * x).sum()],
      [xp.sum()],
      [(xp * y).sum()]
    ], dtype: DType.float64);

    var By = Matrix.fromList([
      [(yp * x).sum()],
      [(yp * y).sum()],
      [yp.sum()]
    ], dtype: DType.float64);

    var Cx = Ax.solve(Bx).toVector();
    var Cy = Ay.solve(By).toVector();

    v = Matrix.fromRows([Cx, Cy], dtype: DType.float64);
  }

  Matrix toSP(Matrix gp) {
    var gp_n = ng.norm(gp);
    var x = gp_n[0];
    var y = gp_n[1];
    double a = v[0][0];
    double b = v[0][1];
    double c = v[0][2];
    double d = v[1][0];
    double e = v[1][1];
    double f = v[1][2];
    var r1 = x * a + y * b + c;
    var r2 = x * d + y * e + f;

    return ns.denorm(Matrix.fromRows([r1, r2], dtype: DType.float64));
  }
}
