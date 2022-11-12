import 'dart:math';

class MathUtils {
  // ax2 + bx + c = 0
  static List<double> nghiemPhuongTrinhBac2(num a, num b, num c) {
    final delta = pow(b, 2) - 4 * a * c;
    if (delta < 0) {
      return [];
    }
    if (delta == 0) {
      return [-b / (2 * a)];
    }
    return [(-b + sqrt(delta)) / (2 * a), (-b - sqrt(delta)) / (2 * a)];
  }

  // I(a;b) J(a2;b2)
  // -> Tìm M(a0;b0) sao cho góc MIJ = alpha độ
  static List<List<double>> baiToan1({
    a = 0.0,
    b = 0.0,
    a2 = 0.0,
    b2 = 0.0,
    degree = 0.0,
  }) {
    final tanAlpha = tan(degree * pi / 180);
    final r = sqrt(pow(a2 - a, 2) + pow(b2 - b, 2));
    // print(
    //     'r: $r, I: ($a, $b), J ($a2, $b2), alpha: $degree, tanAlpha $tanAlpha');
    final c = pow(a, 2) + pow(b, 2) - pow(r, 2);
    final m = (b2 - b) / (a2 - a);
    final m0 = (m - tanAlpha) / (-1 - m * tanAlpha);
    final n0 = b - a * m0;
    List<double> a0List = nghiemPhuongTrinhBac2(1 + pow(m0, 2),
        2 * m0 * n0 - 2 * a - 2 * b * m0, pow(n0, 2) - 2 * b * n0 + c);
    if (a0List.isNotEmpty) {
      final result = <List<double>>[];
      for (var element in a0List) {
        result.add([element, m0 * element + n0]);
      }
      // print('M: ($result)');
      return result;
    }
    return [];
  }
}
