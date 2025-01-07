import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

// Custom painter for the die
class DicePainter extends CustomPainter {
  final int previous;
  final int current;
  final double animationProgress;

  DicePainter(this.previous, this.current, this.animationProgress);

  @override
  void paint(Canvas canvas, Size size) {
    List<Rect> dots = _calculateDots(size);

    // Compression for the current face is animationProgress.
    double previousCompression = 1 - animationProgress;
    double border = size.width * previousCompression;

    // Calculate the dots for the previous face and the current face
    List<Rect> previousDots = dots
        .whereIndexed((idx, _) => _getDots(previous).contains(idx))
        .map((dot) => Rect.fromCenter(
            center: dot.center.scale(previousCompression, 1.0),
            width: dot.width * previousCompression,
            height: dot.height))
        .toList();
    List<Rect> currentDots = dots
        .whereIndexed((idx, _) => _getDots(current).contains(idx))
        .map((dot) => Rect.fromCenter(
            center:
                dot.center.scale(animationProgress, 1.0) + Offset(border, 0),
            width: dot.width * animationProgress,
            height: dot.height))
        .toList();

    // Draw the backgrounds
    canvas.drawRect(
        Rect.fromPoints(const Offset(0, 0), Offset(border, size.height)),
        Paint()..color = _getColor(previous));
    canvas.drawRect(
        Rect.fromPoints(Offset(border, 0), Offset(size.width, size.height)),
        Paint()..color = _getColor(current));
    // Draw the dots
    for (Rect dot in previousDots + currentDots) {
      canvas.drawOval(dot, Paint()..color = Colors.white);
    }
  }

  // Returns which dots are required for the given value.
  List<int> _getDots(int value) {
    return switch (value) {
      1 => [4],
      2 => [0, 8],
      3 => [0, 4, 8],
      4 => [0, 2, 6, 8],
      5 => [0, 2, 4, 6, 8],
      6 => [0, 2, 3, 5, 6, 8],
      _ => []
    };
  }

  // Returns the background color associated with a value.
  Color _getColor(int value) {
    switch (value) {
      case 1:
        return Colors.blue.shade300;
      case 2:
        return Colors.green.shade300;
      case 3:
        return Colors.orange.shade300;
      case 4:
        return Colors.yellow.shade600;
      case 5:
        return Colors.purple.shade300;
      case 6:
        return Colors.red.shade300;
      default:
        return Colors.black;
    }
  }

  // Calculates the Rects where the dots of a die must be located given a certain Size.
  // It returns a list of 9 Rects, 3 for each row.
  // Note that some of the dots are not actually used for a die, but we generate all of them
  // for consistency.
  List<Rect> _calculateDots(Size size) {
    // As first step, square the area if it's rectangular and calculate the offset.
    Offset offset = Offset.zero;
    if (size.width > size.height) {
      offset = Offset((size.width - size.height) / 2, 0);
    } else if (size.width < size.height) {
      offset = Offset(0, (size.height - size.width) / 2);
    }
    double side = size.shortestSide;

    // a = padding between the border and the dots
    // dot = size of the dots. We make sure that it's odd/even based on side.
    // b = space between the dots
    double a = (side * 0.2).floorToDouble();
    double dot = (side * 0.12).floorToDouble();
    if ((dot.toInt().isOdd && side.toInt().isEven) ||
        (dot.toInt().isEven && side.toInt().isOdd)) {
      dot++;
    }
    double b = (side - (3 * dot) - (2 * a)) / 2;

    List<Rect> result = [];
    for (int y = 0; y < 3; y++) {
      double yOffset = y * (dot + b) + a;
      for (int x = 0; x < 3; x++) {
        double xOffset = x * (dot + b) + a;
        Offset o = Offset(xOffset, yOffset) + offset;
        result.add(Rect.fromPoints(o, o + Offset(dot, dot)));
      }
    }
    return result;
  }

  @override
  bool shouldRepaint(DicePainter oldDelegate) {
    return oldDelegate.previous != previous ||
        oldDelegate.current != current ||
        oldDelegate.animationProgress != animationProgress;
  }
}
