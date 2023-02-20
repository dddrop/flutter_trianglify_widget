import '../thread_local_random.dart';
import '../triangulator/vector_2d.dart';
import 'patterns.dart';

class Rectangle implements Patterns {
  Rectangle(this.bleedX, this.bleedY, this.height, this.width, this.cellSize,
      this.variance) {
    random = ThreadLocalRandom();
  }

  late ThreadLocalRandom random;
  int bleedX = 0;
  int bleedY = 0;

  int height = 0;
  int width = 0;

  int cellSize = 0;
  int variance = 0;

  final List<Vector2D> grid = <Vector2D>[];

  @override
  List<Vector2D> generate() {
    grid.clear();

    int x, y;
    for (int j = 0; j < height + 2 * bleedY; j += cellSize) {
      for (int i = 0; i < width + 2 * bleedX; i += cellSize) {
        x = i + random.nextInt(variance);
        y = j + random.nextInt(variance);
        grid.add(Vector2D(x.toDouble(), y.toDouble()));
      }
    }

    return grid;
  }
}
