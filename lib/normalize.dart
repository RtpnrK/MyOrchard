import 'package:ml_linalg/linalg.dart';

class Normalize {
  var mu;
  var std;

  Matrix norm(Matrix m){
    var l = asList(m);
    if(mu == null && std == null){
      mu = Matrix.fromColumns([m.mean(Axis.rows)],dtype: DType.float64);
      std = Matrix.fromColumns([m.variance(Axis.rows).sqrt()],dtype: DType.float64);
    }
    for(int i=0; i<=l.length-1; i++) {
      for(int j=0; j<=l[0].length-1; j++) {
        l[i][j] = (l[i][j] - mu[i][0]) / std[i][0];
      }
   }
    return Matrix.fromList(l,dtype: DType.float64);
  }

  Matrix denorm(Matrix M) {
  var l = asList(M);
  for(int i=0; i<=l.length-1; i++) {
    for(int j=0; j<=l[0].length-1; j++) {
      l[i][j] = (l[i][j] * std[i][0]) + mu[i][0];
    }
  }
  return Matrix.fromList(l,dtype: DType.float64);
}
}

List<List<double>> asList(Matrix M) {
  return M.map((e)=>e.toList()).toList();
}