import 'dart:math';

class Vector2D {
  const Vector2D(this.x, this.y);

  final double x;
  final double y;

  Vector2D sub(Vector2D vector) => Vector2D(x - vector.x, y - vector.y);

  Vector2D add(Vector2D vector) => Vector2D(x + vector.x, y + vector.y);

  Vector2D mult(double scalar) => Vector2D(x * scalar, y * scalar);

  double mag() => sqrt(x * x + y * y);

  double dot(Vector2D vector) => x * vector.x + y * vector.y;

  double cross(Vector2D vector) => x * vector.y - y * vector.x;

  @override
  String toString() => 'Vector2D($x, $y)';
}
