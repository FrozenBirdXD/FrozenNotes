import 'package:flutter/material.dart';
import 'package:frozennotes/services/auth/auth_service.dart';
import 'package:frozennotes/services/cloud/cloud_drawing.dart';
import 'package:frozennotes/services/cloud/cloud_drawing_storage_service.dart';
import 'package:frozennotes/utils/generics/get_arguments.dart';
import 'package:frozennotes/views/drawings/drawing_area.dart';

class CreateUpdateDrawingView extends StatefulWidget {
  const CreateUpdateDrawingView({super.key});

  @override
  State<CreateUpdateDrawingView> createState() =>
      _CreateUpdateDrawingViewState();
}

class _CreateUpdateDrawingViewState extends State<CreateUpdateDrawingView> {
  // current drawing
  CloudDrawing? _drawing;
  // current drawingsservice
  late final CloudDrawingStorageService _drawingsService;

  List<DrawingArea> _points = [];
  late Offset lastPoint;
  late Offset startPoint;
  bool isDrawing = false;

  @override
  void initState() {
    // singleton
    _drawingsService = CloudDrawingStorageService();
    super.initState();
  }

  @override
  void dispose() {
    _saveDrawing();
    super.dispose();
  }

  Future<CloudDrawing> createOrGetDrawing(BuildContext context) async {
    // if widget passed args of type CloudDrawing
    final widgetDrawing = context.getArgument<CloudDrawing>();
    // if drawing update
    if (widgetDrawing != null) {
      _drawing = widgetDrawing;
      // set data of drawing to data of the given drawing
      _points = widgetDrawing.drawingData;
      return widgetDrawing;
    }

    // if drawing addition
    final existingDrawing = _drawing;
    if (existingDrawing != null) {
      return existingDrawing;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newDrawing =
        await _drawingsService.createNewDrawing(ownerUserId: userId);
    _drawing = newDrawing;

    return newDrawing;
  }

  void _saveDrawing() async {
    final drawing = _drawing;
    drawing?.drawingData = _points;
    if (drawing != null) {
      await _drawingsService.updateDrawing(
        drawing: drawing,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Drawing'),
        actions: [
          IconButton(
            onPressed: () {
              _saveDrawing();
            },
            icon: const Icon(Icons.save_rounded),
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: createOrGetDrawing(context),
          builder: (
            context,
            snapshot,
          ) {
            switch (snapshot.connectionState) {
              // when new drawing has been created
              case ConnectionState.done:
                return GestureDetector(
                  onPanDown: _onPanDown,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: MyPainter(points: _points),
                  ),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }

  void _onPanDown(DragDownDetails details) {
    startPoint = details.localPosition;
    lastPoint = details.localPosition;
    setState(() {
      isDrawing = true;
      _points.add(DrawingArea(
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
        _points.add(DrawingArea(
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
      _points.add(DrawingArea(
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
