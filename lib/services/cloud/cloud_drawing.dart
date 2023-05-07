import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frozennotes/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudDrawing {
  final String documentId;
  final String ownerUserId;
  final List<Map<String, dynamic>> drawingData;

  const CloudDrawing({
    required this.documentId,
    required this.ownerUserId,
    required this.drawingData,
  });

  // give snapshot of clouddrawing
  CloudDrawing.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        drawingData = List<Map<String, dynamic>>.from(
            snapshot.data()[drawingDataFieldName]);

  // convert clouddrawing to map
  Map<String, dynamic> toMap() {
    return {
      ownerUserIdFieldName: ownerUserId,
      drawingDataFieldName: drawingData,
    };
  }
}

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({required this.point, required this.areaPaint});

  factory DrawingArea.fromJson(Map<String, dynamic> json) {
    double x = json['x'];
    double y = json['y'];
    Offset point = Offset(x, y);

    Paint areaPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = Color(json['color'])
      ..strokeWidth = json['strokeWidth'];

    return DrawingArea(point: point, areaPaint: areaPaint);
  }

  Map<String, dynamic> toJson() {
    return {
      'x': point.dx,
      'y': point.dy,
      'color': areaPaint.color.value,
      'strokeWidth': areaPaint.strokeWidth,
    };
  }
}
