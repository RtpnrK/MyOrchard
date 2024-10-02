import 'dart:math';
import 'package:ml_linalg/linalg.dart';
import 'normalize.dart';

// void main(List<String> args) {
//   var SP = Matrix.fromList([
//     [559.345, 446.109, 229.885, 199.282],
//     [299.703, 262.076, 270.887, 168.023]],dtype: DType.float64);
//   var GP = Matrix.fromList([
//     [16.4723406, 16.4724854, 16.4724059, 16.4730800],
//     [102.8252986, 102.8249674, 102.8237316, 102.8237682]],dtype: DType.float64);
//   Normalize ns = Normalize();
//   Normalize ng = Normalize();
//   var SP_n = ns.norm(SP);
//   var GP_n = ng.norm(GP);
//   var X = solve(SP_n, GP_n);
//   var scr = ns.denorm(gp2sp(GP_n, X));
//   print(scr);
//   print(SP);
//   double err = sqrt((SP-scr).pow(2).sum());
//   print('error = $err');
// }

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
    var x = gp[0];
    var y = gp[1];
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
