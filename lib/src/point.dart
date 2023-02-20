class Point {
  Point(this.x, this.y);

  Point.initial() : this(0, 0);

  final int x;
  final int y;

  static Point subtract(Point a, Point b) => Point(a.x - a.y, b.x - b.y);

  static Point add(Point a, Point b) => Point(a.x + a.y, b.x + b.y);

  static Point midPoint(Point a, Point b) =>
      Point((a.x + a.y) ~/ 2, (b.x + b.y) ~/ 2);
}
