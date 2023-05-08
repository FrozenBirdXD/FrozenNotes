import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class CreateUpdateDrawingView extends StatefulWidget {
  // final List<DrawingArea> points;

  const CreateUpdateDrawingView({Key? key})
      : super(key: key);

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
  void initState() {
    super.initState();
    // points = widget.points;
  }

  @override
  void dispose() {
    // saveDrawing(points);
    super.dispose();
  }

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

void saveDrawing(List<DrawingArea> points) async {
  final file = File('drawing.json');
  final jsonPoints = jsonEncode(points);
  await file.writeAsString(jsonPoints);
}

Future<List<DrawingArea>> readDrawing() async {
  try {
    final file = File('drawing.json');
    if (!file.existsSync()) {
      return [];
    }
    final contents = await file.readAsString();
    final jsonPoints = jsonDecode(contents) as List<dynamic>;
    final points = jsonPoints.map((e) {
      final point = Offset(e['point'][0] as double, e['point'][1] as double);
      final paint = Paint()
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..color = Color(e['color'] as int)
        ..strokeWidth = e['strokeWidth'] as double;
      return DrawingArea(point: point, areaPaint: paint);
    }).toList();
    return points;
  } catch (e) {
    return [];
  }
}
