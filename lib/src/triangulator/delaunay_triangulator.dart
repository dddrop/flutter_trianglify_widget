import 'dart:math';

import 'edge_2d.dart';
import 'triangle_2d.dart';
import 'triangle_soup.dart';
import 'vector_2d.dart';

class DelaunayTriangulator {
  DelaunayTriangulator(this.pointSet) : triangleSoup = TriangleSoup();

  List<Vector2D> pointSet;
  final TriangleSoup triangleSoup;

  void triangulate() {
    if (pointSet == null || pointSet.length < 3) {
      throw Exception('Less than three points in point set.');
    }

    double maxOfAnyCoordinate = 0.0;

    for (final Vector2D vector in getPointSet()) {
      maxOfAnyCoordinate = max(max(vector.x, vector.y), maxOfAnyCoordinate);
    }

    maxOfAnyCoordinate *= 16.0;

    final double newCoordinate = 3.0 * maxOfAnyCoordinate;
    final Vector2D p1 = Vector2D(0.0, newCoordinate);
    final Vector2D p2 = Vector2D(newCoordinate, 0.0);
    final Vector2D p3 = Vector2D(-newCoordinate, -newCoordinate);

    final Triangle2D superTriangle = Triangle2D(p1, p2, p3);

    triangleSoup.add(superTriangle);

    for (int i = 0; i < pointSet.length - 1; i++) {
      final Triangle2D? triangle =
          triangleSoup.findContainingTriangle(pointSet[i]);

      if (triangle == null) {
        final Edge2D edge = triangleSoup.findNearestEdge(pointSet[i]);

        final Triangle2D? first = triangleSoup.findOneTriangleSharing(edge);
        if (first == null) {
          throw Exception('First triangle is null.');
        }
        final Triangle2D? second = triangleSoup.findNeighbour(first, edge);

        final Vector2D? firstNoneEdgeVertex = first.getNoneEdgeVertex(edge);
        final Vector2D? secondNoneEdgeVertex = second?.getNoneEdgeVertex(edge);

        triangleSoup.remove(first);
        triangleSoup.remove(second!);

        final Triangle2D triangle1 =
            Triangle2D(edge.a, firstNoneEdgeVertex!, pointSet[i]);
        final Triangle2D triangle2 =
            Triangle2D(edge.b, firstNoneEdgeVertex, pointSet[i]);
        final Triangle2D triangle3 =
            Triangle2D(edge.a, secondNoneEdgeVertex!, pointSet[i]);
        final Triangle2D triangle4 =
            Triangle2D(edge.b, secondNoneEdgeVertex, pointSet[i]);

        triangleSoup.add(triangle1);
        triangleSoup.add(triangle2);
        triangleSoup.add(triangle3);
        triangleSoup.add(triangle4);

        legalizeEdge(
            triangle1, Edge2D(edge.a, firstNoneEdgeVertex), pointSet[i]);
        legalizeEdge(
            triangle2, Edge2D(edge.b, firstNoneEdgeVertex), pointSet[i]);
        legalizeEdge(
            triangle3, Edge2D(edge.a, secondNoneEdgeVertex), pointSet[i]);
        legalizeEdge(
            triangle4, Edge2D(edge.b, secondNoneEdgeVertex), pointSet[i]);
      } else {
        /// The vertex is inside a triangle.
        final Vector2D a = triangle.a;
        final Vector2D b = triangle.b;
        final Vector2D c = triangle.c;

        triangleSoup.remove(triangle);

        final Triangle2D first = Triangle2D(a, b, pointSet[i]);
        final Triangle2D second = Triangle2D(b, c, pointSet[i]);
        final Triangle2D third = Triangle2D(c, a, pointSet[i]);

        triangleSoup.add(first);
        triangleSoup.add(second);
        triangleSoup.add(third);

        legalizeEdge(first, Edge2D(a, b), pointSet[i]);
        legalizeEdge(second, Edge2D(b, c), pointSet[i]);
        legalizeEdge(third, Edge2D(c, a), pointSet[i]);
      }
    }

    triangleSoup.removeTrianglesUsing(superTriangle.a);
    triangleSoup.removeTrianglesUsing(superTriangle.b);
    triangleSoup.removeTrianglesUsing(superTriangle.c);
  }

  void legalizeEdge(Triangle2D triangle, Edge2D edge, Vector2D newVertex) {
    final Triangle2D? neighbourTriangle =
        triangleSoup.findNeighbour(triangle, edge);

    if (neighbourTriangle != null) {
      if (neighbourTriangle.isPointInCircumcircle(newVertex)) {
        triangleSoup.remove(triangle);
        triangleSoup.remove(neighbourTriangle);

        final Vector2D? noneEdgeVertex =
            neighbourTriangle.getNoneEdgeVertex(edge);

        final Triangle2D firstTriangle =
            Triangle2D(noneEdgeVertex!, edge.a, newVertex);
        final Triangle2D secondTriangle =
            Triangle2D(noneEdgeVertex, edge.b, newVertex);

        triangleSoup.add(firstTriangle);
        triangleSoup.add(secondTriangle);

        legalizeEdge(firstTriangle, Edge2D(noneEdgeVertex, edge.a), newVertex);
        legalizeEdge(secondTriangle, Edge2D(noneEdgeVertex, edge.b), newVertex);
      }
    }
  }

  void shuffle() {
    pointSet.shuffle();
  }

  void shuffleThePointSet(List<int> permutation) {
    final List<Vector2D> temp = <Vector2D>[];
    for (int i = 0; i < permutation.length; i++) {
      temp.add(pointSet[permutation[i]]);
    }
    pointSet = temp;
  }

  List<Vector2D> getPointSet() => pointSet;

  List<Triangle2D> get triangles => triangleSoup.triangles;
}
