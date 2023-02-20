import 'edge_2d.dart';
import 'edge_distance_pack.dart';
import 'triangle_2d.dart';
import 'vector_2d.dart';

class TriangleSoup {
  TriangleSoup();

  Set<Triangle2D> triangleSoup = <Triangle2D>{};

  void add(Triangle2D triangle) {
    triangleSoup.add(triangle);
  }

  void remove(Triangle2D triangle) {
    triangleSoup.remove(triangle);
  }

  List<Triangle2D> get triangles => triangleSoup.toList();

  Triangle2D? findContainingTriangle(Vector2D point) {
    for (final Triangle2D triangle in triangleSoup) {
      if (triangle.contains(point)) {
        return triangle;
      }
    }
    return null;
  }

  Triangle2D? findNeighbour(Triangle2D triangle, Edge2D edge) {
    for (final Triangle2D triangleFromSoup in triangleSoup) {
      if (triangleFromSoup.isNeighbour(edge) && triangleFromSoup != triangle) {
        return triangleFromSoup;
      }
    }
    return null;
  }

  Triangle2D? findOneTriangleSharing(Edge2D edge) {
    for (final Triangle2D triangle in triangleSoup) {
      if (triangle.isNeighbour(edge)) {
        return triangle;
      }
    }
    return null;
  }

  Edge2D findNearestEdge(Vector2D point) {
    final List<EdgeDistancePack> edgeList = <EdgeDistancePack>[];
    for (final Triangle2D triangle in triangleSoup) {
      edgeList.add(triangle.findNearestEdge(point));
    }
    edgeList.sort();
    return edgeList[0].edge;
  }

  void removeTrianglesUsing(Vector2D vertex) {
    final List<Triangle2D> trianglesToBeRemoved = <Triangle2D>[];

    for (final Triangle2D triangle in triangleSoup) {
      if (triangle.hasVertex(vertex)) {
        trianglesToBeRemoved.add(triangle);
      }
    }

    triangleSoup.removeAll(trianglesToBeRemoved);
  }
}
