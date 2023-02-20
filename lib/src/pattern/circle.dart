import 'dart:math';

import '../triangulator/vector_2d.dart';
import 'patterns.dart';

class Circle implements Patterns {
  Circle(this.bleedX, this.bleedY, this.pointsPerCircle, this.height,
      this.width, this.cellSize, this.variance) {
    grid = <Vector2D>[];
  }

  final Random random = Random();
  int bleedX = 0;
  int bleedY = 0;
  int pointsPerCircle = 8;

  int height = 0;
  int width = 0;

  int cellSize = 0;
  int variance = 0;

  late List<Vector2D> grid;

  Random getRandom() {
    return random;
  }

  @override
  List<Vector2D> generate() {
    final Vector2D center = Vector2D(width / 2, height / 2);

    grid.clear();

    final int maxRadius = max(width + bleedX, height + bleedY);
    grid.add(center);

    double slice, angle;
    double x, y;

    for (int radius = cellSize; radius < maxRadius; radius += cellSize) {
      slice = 2 * pi / pointsPerCircle;
      for (int i = 0; i < pointsPerCircle; i++) {
        angle = slice * i;
        x = (center.x + radius * cos(angle)) + random.nextInt(variance);
        y = (center.y + radius * sin(angle)) + random.nextInt(variance);
        grid.add(Vector2D(x, y));
      }
    }

    return grid;
  }
}
