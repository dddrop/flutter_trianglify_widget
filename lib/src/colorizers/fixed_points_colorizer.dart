import 'package:flutter/foundation.dart';

import '../extended_color.dart';
import '../palette.dart';
import '../point.dart';
import '../thread_local_random.dart';
import '../triangulation.dart';
import '../triangulator/triangle_2d.dart';
import '../triangulator/vector_2d.dart';
import 'colorizer.dart';

class FixedPointsColorizer implements Colorizer {
  FixedPointsColorizer(
    this.triangulation,
    this.colorPalette,
    this.gridHeight,
    this.gridWidth,
    this.randomColoring,
  ) {
    random = ThreadLocalRandom(DateTime.now().millisecond);
  }

  FixedPointsColorizer.fromDefault(Triangulation triangulation,
      Palette colorPalette, int gridHeight, int gridWidth)
      : this(triangulation, colorPalette, gridHeight, gridWidth, false);

  late ThreadLocalRandom random;
  Triangulation triangulation;
  Palette colorPalette;

  int gridWidth;
  int gridHeight;

  bool randomColoring = false;

  @override
  Triangulation getColororedTriangulation() {
    if (triangulation != null) {
      for (final Triangle2D triangle in triangulation.triangleList) {
        triangle.color = getColorForPoint(triangle.getCentroid());
      }
    } else {
      if (kDebugMode) {
        print('colorizeTriangulation: Triangulation cannot be null!');
      }
    }
    return triangulation;
  }

  int getColorForPoint(Vector2D point) {
    if (randomColoring) {
      return colorPalette.getColor(random.nextInt(9));
    } else {
      ExtendedColor topLeftColor, topRightColor;
      ExtendedColor bottomLeftColor, bottomRightColor;

      Point topLeft, topRight;
      Point bottomLeft, bottomRight;

      // Following if..else identifies which sub-rectangle given point lies
      if (point.x < gridWidth / 2 && point.y < gridHeight / 2) {
        topLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(0));
        topRightColor = ExtendedColor.fromPalette(colorPalette.getColor(1));
        bottomLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(7));
        bottomRightColor = ExtendedColor.fromPalette(colorPalette.getColor(8));
      } else if (point.x >= gridWidth / 2 && point.y < gridHeight / 2) {
        topLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(1));
        topRightColor = ExtendedColor.fromPalette(colorPalette.getColor(2));
        bottomLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(8));
        bottomRightColor = ExtendedColor.fromPalette(colorPalette.getColor(3));
      } else if (point.x >= gridWidth / 2 && point.y >= gridHeight / 2) {
        topLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(8));
        topRightColor = ExtendedColor.fromPalette(colorPalette.getColor(3));
        bottomLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(5));
        bottomRightColor = ExtendedColor.fromPalette(colorPalette.getColor(4));
      } else {
        topLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(7));
        topRightColor = ExtendedColor.fromPalette(colorPalette.getColor(8));
        bottomLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(6));
        bottomRightColor = ExtendedColor.fromPalette(colorPalette.getColor(5));
      }

      topLeft = Point((point.x >= gridWidth ~/ 2) ? gridWidth ~/ 2 : 0,
          (point.y >= gridHeight ~/ 2) ? gridHeight ~/ 2 : 0);
      topRight = Point((point.x >= gridWidth ~/ 2) ? gridWidth : gridWidth ~/ 2,
          (point.y >= gridHeight ~/ 2) ? gridHeight ~/ 2 : 0);
      bottomLeft = Point((point.x >= gridWidth ~/ 2) ? gridWidth ~/ 2 : 0,
          (point.y >= gridHeight ~/ 2) ? gridHeight : gridHeight ~/ 2);
      bottomRight = Point(
          (point.x >= gridWidth ~/ 2) ? gridWidth : gridWidth ~/ 2,
          (point.y >= gridHeight ~/ 2) ? gridHeight : gridHeight ~/ 2);

      final ExtendedColor weightedTopColor = ExtendedColor.fromRGB(
          (topRightColor.r * (point.x - topLeft.x) +
                  (topLeftColor.r) * (topRight.x - point.x)) ~/
              (topRight.x - topLeft.x),
          (topRightColor.g * (point.x - topLeft.x) +
                  (topLeftColor.g) * (topRight.x - point.x)) ~/
              (topRight.x - topLeft.x),
          (topRightColor.b * (point.x - topLeft.x) +
                  (topLeftColor.b) * (topRight.x - point.x)) ~/
              (topRight.x - topLeft.x));
      final ExtendedColor weightedBottomColor = ExtendedColor.fromRGB(
          (bottomRightColor.r * (point.x - topLeft.x) +
                  (bottomLeftColor.r) * (topRight.x - point.x)) ~/
              (topRight.x - topLeft.x),
          (bottomRightColor.g * (point.x - topLeft.x) +
                  (bottomLeftColor.g) * (topRight.x - point.x)) ~/
              (topRight.x - topLeft.x),
          (bottomRightColor.b * (point.x - topLeft.x) +
                  (bottomLeftColor.b) * (topRight.x - point.x)) ~/
              (topRight.x - topLeft.x));
      final ExtendedColor weightedLeftColor = ExtendedColor.fromRGB(
          (bottomLeftColor.r * (point.y - topLeft.y) +
                  (topLeftColor.r) * (bottomLeft.y - point.y)) ~/
              (bottomLeft.y - topLeft.y),
          (bottomLeftColor.g * (point.y - topLeft.y) +
                  (topLeftColor.g) * (bottomLeft.y - point.y)) ~/
              (bottomLeft.y - topLeft.y),
          (bottomLeftColor.b * (point.y - topLeft.y) +
                  (topLeftColor.b) * (bottomLeft.y - point.y)) ~/
              (bottomLeft.y - topLeft.y));

      final ExtendedColor weightedRightColor = ExtendedColor.fromRGB(
          (bottomRightColor.r * (point.y - topRight.y) +
                  (topRightColor.r) * (bottomRight.y - point.y)) ~/
              (bottomRight.y - topRight.y),
          (bottomRightColor.g * (point.y - topRight.y) +
                  (topRightColor.g) * (bottomRight.y - point.y)) ~/
              (bottomRight.y - topRight.y),
          (bottomRightColor.b * (point.y - topRight.y) +
                  (topRightColor.b) * (bottomRight.y - point.y)) ~/
              (bottomRight.y - topRight.y));

      final ExtendedColor weightedYColor = ExtendedColor.fromRGB(
          (weightedRightColor.r * (point.x - topLeft.x) +
                  (weightedLeftColor.r) * (topRight.x - point.x)) ~/
              (topRight.x - topLeft.x),
          (weightedRightColor.g * (point.x - topLeft.x) +
                  (weightedLeftColor.g) * (topRight.x - point.x)) ~/
              (topRight.x - topLeft.x),
          (weightedRightColor.b * (point.x - topLeft.x) +
                  (weightedLeftColor.b) * (topRight.x - point.x)) ~/
              (topRight.x - topLeft.x));

      final ExtendedColor weightedXColor = ExtendedColor.fromRGB(
          (weightedBottomColor.r * (point.y - topLeft.y) +
                  (weightedTopColor.r) * (bottomLeft.y - point.y)) ~/
              (bottomLeft.y - topLeft.y),
          (weightedBottomColor.g * (point.y - topLeft.y) +
                  (weightedTopColor.g) * (bottomLeft.y - point.y)) ~/
              (bottomLeft.y - topLeft.y),
          (weightedBottomColor.b * (point.y - topLeft.y) +
                  (weightedTopColor.b) * (bottomLeft.y - point.y)) ~/
              (bottomLeft.y - topLeft.y));

      return ExtendedColor.avg(weightedXColor, weightedYColor).toInt();
    }
  }

  int avg(List<int> args) {
    int sum = 0;
    for (final int arg in args) {
      sum += arg;
    }
    return sum ~/ args.length;
  }
}
