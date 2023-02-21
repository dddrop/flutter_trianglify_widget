import 'package:flutter/material.dart';

import 'abstract_trianglify.dart';
import 'palette.dart';
import 'triangulation.dart';
import 'triangulator/triangle_2d.dart';

class TrianglifyWidget extends AbstractTrianglify {
  const TrianglifyWidget({
    super.key,
    required super.bleedX,
    required super.bleedY,
    required super.typeGrid,
    required super.gridWidth,
    required super.gridHeight,
    required super.variance,
    required super.cellSize,
    required super.isFillViewCompletely,
    required super.isFillTriangle,
    required super.isDrawStroke,
    required super.isRandomColoring,
    required super.palette,
    required super.triangulation,
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
        assert(triangulation != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        width: gridWidth - 50,
        height: gridHeight - 50,
        child: ClipRect(
          child: CustomPaint(
            painter: _TrianglifyWidgetPainter(
              bleedX: 75 + bleedX,
              bleedY: 28 + bleedY,
              typeGrid: typeGrid,
              gridWidth: gridWidth,
              gridHeight: gridHeight,
              variance: variance,
              cellSize: cellSize,
              isFillViewCompletely: isFillViewCompletely,
              isFillTriangle: isFillTriangle,
              isDrawStroke: isDrawStroke,
              isRandomColoring: isRandomColoring,
              palette: palette,
              triangulation: triangulation,
            ),
            isComplex: true,
          ),
        ),
      ),
    );
  }
}

class _TrianglifyWidgetPainter extends CustomPainter {
  _TrianglifyWidgetPainter({
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
    required this.triangulation,
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
        assert(triangulation != null);

  static const double BASE_SIZE = 320.0;
  static const double STROKE_WIDTH = 1.0;

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
  final Triangulation triangulation;
  bool? generateOnlyColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleFactor = size.shortestSide / BASE_SIZE;
    final Offset center = (Offset.zero & size).center;
    _plotOnCanvas(canvas, center, size, scaleFactor);
  }

  @override
  bool shouldRepaint(_TrianglifyWidgetPainter oldTrianglifyPainter) {
    return oldTrianglifyPainter.bleedX != bleedX ||
        oldTrianglifyPainter.bleedY != bleedY ||
        oldTrianglifyPainter.cellSize != cellSize ||
        oldTrianglifyPainter.gridWidth != gridWidth ||
        oldTrianglifyPainter.gridHeight != gridHeight ||
        oldTrianglifyPainter.typeGrid != typeGrid ||
        oldTrianglifyPainter.isDrawStroke != isDrawStroke ||
        oldTrianglifyPainter.isFillTriangle != isFillTriangle ||
        oldTrianglifyPainter.isFillViewCompletely != isFillViewCompletely ||
        oldTrianglifyPainter.isRandomColoring != isRandomColoring ||
        oldTrianglifyPainter.palette != palette ||
        oldTrianglifyPainter.triangulation != triangulation;
  }

  void _plotOnCanvas(
      Canvas canvas, Offset center, Size size, double scaleFactor) {
    for (int i = 0; i < triangulation.triangleList.length - 1; i++) {
      _drawTriangle(
          canvas, center, size, scaleFactor, triangulation.triangleList[i]);
    }
  }

  void _drawTriangle(Canvas canvas, Offset center, Size size,
      double scaleFactor, Triangle2D triangle2D) {
    final Paint paint = Paint();
    int color = triangle2D.color ?? 0;

    color += 0xff000000;

    paint.color = Color(color);
    paint.strokeWidth = STROKE_WIDTH;

    if (isFillTriangle && isDrawStroke) {
      paint.style = PaintingStyle.fill;
    } else if (isFillTriangle) {
      paint.style = PaintingStyle.fill;
    } else if (isDrawStroke) {
      paint.style = PaintingStyle.stroke;
    } else {
      paint.style = PaintingStyle.fill;
    }

    paint.isAntiAlias = true;

    final Path path = Path();
    path.fillType = PathFillType.evenOdd;

    path.moveTo((triangle2D.a.x) - (bleedX * scaleFactor),
        (triangle2D.a.y) - (bleedY * scaleFactor));
    path.lineTo((triangle2D.b.x) - (bleedX * scaleFactor),
        (triangle2D.b.y) - (bleedY * scaleFactor));
    path.lineTo((triangle2D.c.x) - (bleedX * scaleFactor),
        (triangle2D.c.y) - bleedY * scaleFactor);
    path.lineTo((triangle2D.a.x) - (bleedX * scaleFactor),
        (triangle2D.a.y) - bleedY * scaleFactor);
    path.close();

    canvas.drawPath(path, paint);
  }
}
