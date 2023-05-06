import 'package:flutter/material.dart';

class CreateUpdateDrawingView extends StatefulWidget {
  const CreateUpdateDrawingView({super.key});

  @override
  State<CreateUpdateDrawingView> createState() =>
      _CreateUpdateDrawingViewState();
}

class _CreateUpdateDrawingViewState extends State<CreateUpdateDrawingView> {
  List<DrawingArea> points = [];
  late Offset lastPoint;
  late Offset startPoint;
  bool isDrawing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Drawing')),
      body: SafeArea(
        child: GestureDetector(
          onPanDown: _onPanDown,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: CustomPaint(
            size: Size.infinite,
            painter: MyPainter(points: points),
          ),
        ),
      ),
    );
  }

  void _onPanDown(DragDownDetails details) {
    startPoint = details.localPosition;
    lastPoint = details.localPosition;
    setState(() {
      isDrawing = true;
      points.add(DrawingArea(
        point: lastPoint,
        areaPaint: Paint()
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..color = Colors.black
          ..strokeWidth = 5.0,
      ));
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (isDrawing) {
      setState(() {
        lastPoint = details.localPosition;
        points.add(DrawingArea(
          point: lastPoint,
          areaPaint: Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..color = Colors.black
            ..strokeWidth = 5.0,
        ));
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDrawing = false;
      points.add(DrawingArea(
        point: Offset.infinite,
        areaPaint: Paint(),
      ));
    });
  }
}

class MyPainter extends CustomPainter {
  List<DrawingArea> points;

  MyPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].point != Offset.infinite &&
          points[i + 1].point != Offset.infinite) {
        canvas.drawLine(
            points[i].point, points[i + 1].point, points[i].areaPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(MyPainter oldDelegate) {
    return false;
  }
}

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({required this.point, required this.areaPaint});
}
