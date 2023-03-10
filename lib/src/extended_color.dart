import 'package:flutter/material.dart';

class ExtendedColor extends Color {
  ExtendedColor.fromARGB(this.a, this.r, this.g, this.b)
      : super.fromARGB(a, r, g, b);

  ExtendedColor.fromPalette(int palleteColor)
      : this.fromARGB(0xFF, palleteColor >> 4 * 4,
            (palleteColor >> 4 * 2) & 0xFF, palleteColor & 0xFF);

  ExtendedColor.fromRGB(int r, int g, int b) : this.fromARGB(0xFF, r, g, b);

  final int a;
  final int r;
  final int g;
  final int b;

  static ExtendedColor avg(ExtendedColor c0, ExtendedColor c1) {
    return ExtendedColor.fromARGB((c0.a + c1.a) ~/ 2, (c0.r + c1.r) ~/ 2,
        (c0.g + c1.g) ~/ 2, (c0.b + c1.b) ~/ 2);
  }

  int toInt() {
    return ExtendedColor.fromARGB(a, r, g, b).value;
  }
}
