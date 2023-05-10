import 'dart:ui';

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({required this.point, required this.areaPaint});

  // constructor to create a DrawingArea object from a map
  DrawingArea.fromMap(Map<String, dynamic>? map)
      : point = Offset((map?['point.dx'] ?? 0).toDouble(),
            (map?['point.dy'] ?? 0).toDouble()),
        areaPaint = Paint()
          ..color = Color(map?['areaPaint.color'] ?? 0xFF000000)
          ..strokeWidth = (map?['areaPaint.strokeWidth'] ?? 1).toDouble();

  Map<String, dynamic> toMap() {
    return {
      'point': {'x': point.dx, 'y': point.dy},
      'areaPaint': {
        'color': areaPaint.color.value,
        'strokeWidth': areaPaint.strokeWidth,
      },
    };
  }
}
