import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'colorizers/colorizer.dart';
import 'colorizers/fixed_points_colorizer.dart';
import 'palette.dart';
import 'pattern/circle.dart';
import 'pattern/patterns.dart';
import 'pattern/rectangle.dart';
import 'trianglify_widget.dart';
import 'triangulation.dart';
import 'triangulator/delaunay_triangulator.dart';
import 'triangulator/vector_2d.dart';

class Trianglify extends StatelessWidget {
  const Trianglify({
    super.key,
    required this.bleedX,
    required this.bleedY,
    required this.typeGrid,
    required this.gridWidth,
    required this.gridHeight,
    required this.variance,
    required this.cellSize,
    required this.isFillViewCompletely,
    required this.isFillTriangle,
    required this.isDrawStroke,
    required this.isRandomColoring,
    required this.palette,
    this.triangulation,
    required this.generateOnlyColor,
  })  : assert(bleedX != null),
        assert(bleedY != null),
        assert(typeGrid != null),
        assert(gridWidth != null),
        assert(gridHeight != null),
        assert(variance != null),
        assert(cellSize != null),
        assert(isFillViewCompletely != null),
        assert(isFillTriangle != null),
        assert(isDrawStroke != null),
        assert(isRandomColoring != null),
        assert(palette != null),
        assert(bleedY <= cellSize || bleedX <= cellSize);
  static const int GRID_RECTANGLE = 0;
  static const int GRID_CIRCLE = 1;

  final double bleedX;
  final double bleedY;
  final int typeGrid;
  final double gridWidth;
  final double gridHeight;
  final double variance;
  final double cellSize;
  final bool isFillViewCompletely;
  final bool isFillTriangle;
  final bool isDrawStroke;
  final bool isRandomColoring;
  final Palette palette;
  final Triangulation? triangulation;
  final bool generateOnlyColor;

  Future<Triangulation> _generate() async => _getSoup();

  Future<Triangulation> _getSoup() async {
    if (generateOnlyColor) {
      return _generateColoredSoup(_generateSoup());
    } else {
      return _generateSoup();
    }
  }

  Triangulation _generateSoup() =>
      _generateColoredSoup(_generateTriangulation(_generateGrid()));

  Triangulation _generateTriangulation(List<Vector2D> inputGrid) {
    final DelaunayTriangulator triangulator = DelaunayTriangulator(inputGrid);
    try {
      triangulator.triangulate();
    } on Exception {
      if (kDebugMode) {
        print('Error on generateTriangulation');
      }
    }
    return Triangulation(triangulator.triangles);
  }

  Triangulation _generateColoredSoup(Triangulation inputTriangulation) {
    final Colorizer colorizer = FixedPointsColorizer(
        inputTriangulation,
        palette,
        (gridHeight + 2 * bleedY).toInt(),
        (gridWidth + 2 * bleedX).toInt(),
        randomColoring: isRandomColoring);
    return colorizer.getColororedTriangulation();
  }

  List<Vector2D> _generateGrid() {
    final int gridType = typeGrid;
    Patterns patterns;

    switch (gridType) {
      case GRID_RECTANGLE:
        patterns = Rectangle(bleedX.toInt(), bleedY.toInt(), gridHeight.toInt(),
            gridWidth.toInt(), cellSize.toInt(), variance.toInt());
        break;
      case GRID_CIRCLE:
        patterns = Circle(bleedX.toInt(), bleedY.toInt(), 8, gridHeight.toInt(),
            gridWidth.toInt(), cellSize.toInt(), variance.toInt());
        break;
      default:
        patterns = Rectangle(bleedX.toInt(), bleedY.toInt(), gridHeight.toInt(),
            gridWidth.toInt(), cellSize.toInt(), variance.toInt());
        break;
    }

    return patterns.generate();
  }

  @override
  Widget build(BuildContext context) {
    if (triangulation == null) {
      return FutureBuilder<Triangulation>(
        future: _generate(),
        builder: (BuildContext context, AsyncSnapshot<Triangulation> snapshot) {
          if (snapshot.hasData) {
            return TrianglifyWidget(
              bleedX: bleedX,
              bleedY: bleedY,
              cellSize: cellSize,
              gridWidth: gridWidth,
              gridHeight: gridHeight,
              isDrawStroke: isDrawStroke,
              isFillTriangle: isFillTriangle,
              isFillViewCompletely: isFillViewCompletely,
              isRandomColoring: isRandomColoring,
              typeGrid: typeGrid,
              variance: variance,
              palette: palette,
              triangulation: snapshot.data!,
            );
          } else {
            return Container();
          }
        },
      );
    } else {
      return TrianglifyWidget(
        bleedX: bleedX,
        bleedY: bleedY,
        cellSize: cellSize,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        isDrawStroke: isDrawStroke,
        isFillTriangle: isFillTriangle,
        isFillViewCompletely: isFillViewCompletely,
        isRandomColoring: isRandomColoring,
        typeGrid: typeGrid,
        variance: variance,
        palette: palette,
        triangulation: triangulation!,
      );
    }
  }
}
