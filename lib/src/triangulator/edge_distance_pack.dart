import 'edge_2d.dart';

class EdgeDistancePack implements Comparable<EdgeDistancePack> {
  EdgeDistancePack(this.edge, this.distance);

  final Edge2D edge;
  final double distance;

  @override
  int compareTo(EdgeDistancePack o) => distance.compareTo(o.distance);
}
