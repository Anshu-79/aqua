import 'package:flutter/material.dart';
import 'dart:math';

import 'package:aqua/utils/colors.dart';

class Shape {
  Offset position;
  final Color color;
  final ShapeType type;
  final double size;
  final double speed;

  Shape(this.position, this.color, this.type, this.size, this.speed);
}

enum ShapeType { circle, rectangle, triangle }

class ShapePainter extends CustomPainter {
  final List<Shape> shapes;

  ShapePainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final shape in shapes) {
      paint.color = shape.color;

      switch (shape.type) {
        case ShapeType.circle:
          canvas.drawCircle(shape.position, shape.size, paint);
          break;
        case ShapeType.rectangle:
          canvas.drawRect(
            Rect.fromCenter(
              center: shape.position,
              width: shape.size,
              height: shape.size,
            ),
            paint,
          );
          break;
        case ShapeType.triangle:
          final path = Path();
          path.moveTo(shape.position.dx, shape.position.dy - shape.size);
          path.lineTo(
              shape.position.dx + shape.size, shape.position.dy + shape.size);
          path.lineTo(
              shape.position.dx - shape.size, shape.position.dy + shape.size);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ColoredShapesBackground extends StatefulWidget {
  @override
  _ColoredShapesBackgroundState createState() =>
      _ColoredShapesBackgroundState();
}

class _ColoredShapesBackgroundState extends State<ColoredShapesBackground>
    with SingleTickerProviderStateMixin {
  final List<Color> colorList = shapeColors;
  final List<Shape> shapes = [];
  late AnimationController _controller;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    // Initialize shapes
    while (shapes.length < 40) {
      double size = random.nextDouble() * 30 + 10;
      double xPos = random.nextDouble() * 500;
      double yPos;

      // Ensure shapes are placed at the top or bottom, not in the middle
      if (random.nextBool()) {
        yPos = random.nextDouble() * 200; // Top part
      } else {
        yPos = 600 + random.nextDouble() * 200; // Bottom part
      }

      Offset newPosition = Offset(xPos, yPos);
      ShapeType type =
          ShapeType.values[random.nextInt(ShapeType.values.length)];
      Color color = colorList[random.nextInt(colorList.length)];
      double speed = random.nextDouble() * 0.5 + 2;

      Shape newShape = Shape(newPosition, color, type, size, speed);

      bool overlaps = shapes.any((shape) => _doShapesOverlap(shape, newShape));
      if (!overlaps) {
        shapes.add(newShape);
      }
    }

    // Initialize animation controller and animation
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _updateShapePositions();
      });
    });
  }

  void _updateShapePositions() {
    for (var shape in shapes) {
      shape.position = shape.position
          .translate(shape.speed, 0); // Move horizontally with individual speed
      if (shape.position.dx > 500)
        shape.position =
            Offset(0, shape.position.dy); // wrap around horizontally
    }
  }

  bool _doShapesOverlap(Shape shape1, Shape shape2) {
    double distance = (shape1.position - shape2.position).distance;
    return distance < (shape1.size + shape2.size);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: ShapePainter(shapes),
    );
  }
}
