import 'edge_2d.dart';
import 'edge_distance_pack.dart';
import 'vector_2d.dart';

class Triangle2D {
  Triangle2D(this.a, this.b, this.c, [this.color]);

  final Vector2D a;
  final Vector2D b;
  final Vector2D c;
  int? color;

  bool contains(Vector2D point) {
    final double pab = point.sub(a).cross(b.sub(a));
    final double pbc = point.sub(b).cross(c.sub(b));

    if (!hasSameSign(pab, pbc)) {
      return false;
    }

    final double pca = point.sub(c).cross(a.sub(c));

    if (!hasSameSign(pab, pca)) {
      return false;
    }

    return true;
  }

  bool isPointInCircumcircle(Vector2D point) {
    final double a11 = a.x - point.x;
    final double a21 = b.x - point.x;
    final double a31 = c.x - point.x;

    final double a12 = a.y - point.y;
    final double a22 = b.y - point.y;
    final double a32 = c.y - point.y;

    final double a13 =
        (a.x - point.x) * (a.x - point.x) + (a.y - point.y) * (a.y - point.y);
    final double a23 =
        (b.x - point.x) * (b.x - point.x) + (b.y - point.y) * (b.y - point.y);
    final double a33 =
        (c.x - point.x) * (c.x - point.x) + (c.y - point.y) * (c.y - point.y);

    final double det = a11 * a22 * a33 +
        a12 * a23 * a31 +
        a13 * a21 * a32 -
        a13 * a22 * a31 -
        a12 * a21 * a33 -
        a11 * a23 * a32;

    if (isOrientedCCW()) {
      return det > 0.0;
    }

    return det < 0.0;
  }

  bool hasSameSign(double a, double b) => a.sign == b.sign;

  bool isOrientedCCW() {
    final double a11 = a.x - c.x;
    final double a21 = b.x - c.x;

    final double a12 = a.y - c.y;
    final double a22 = b.y - c.y;

    final double det = a11 * a22 - a12 * a21;

    return det > 0.0;
  }

  bool isNeighbour(Edge2D edge) {
    return (a == edge.a || b == edge.a || c == edge.a) &&
        (a == edge.b || b == edge.b || c == edge.b);
  }

  Vector2D? getNoneEdgeVertex(Edge2D edge) {
    if (a != edge.a && a != edge.b) {
      return a;
    } else if (b != edge.a && b != edge.b) {
      return b;
    } else if (c != edge.a && c != edge.b) {
      return c;
    }
    return null;
  }

  bool hasVertex(Vector2D vertex) => a == vertex || b == vertex || c == vertex;

  EdgeDistancePack findNearestEdge(Vector2D point) {
    return (<EdgeDistancePack>[
      EdgeDistancePack(Edge2D(a, b),
          computeClosestPoint(Edge2D(a, b), point).sub(point).mag()),
      EdgeDistancePack(Edge2D(b, c),
          computeClosestPoint(Edge2D(b, c), point).sub(point).mag()),
      EdgeDistancePack(Edge2D(c, a),
          computeClosestPoint(Edge2D(c, a), point).sub(point).mag()),
    ]..sort())[0];
  }

  Vector2D computeClosestPoint(Edge2D edge, Vector2D point) {
    final Vector2D ab = edge.b.sub(edge.a);
    double t = point.sub(edge.a).dot(ab) / ab.dot(ab);

    if (t < 0.0) {
      t = 0.0;
    } else if (t > 1.0) {
      t = 1.0;
    }

    return edge.a.add(ab.mult(t));
  }

  Vector2D getCentroid() {
    final double x = ((a.x) + (b.x) + (c.x)) / 3;
    final double y = ((a.y) + (b.y) + (c.y)) / 3;
    return Vector2D(x, y);
  }

  @override
  String toString() => 'Triangle2D($a, $b, $c)';
}
