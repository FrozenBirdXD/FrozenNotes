import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frozennotes/services/cloud/cloud_storage_constants.dart';
import 'package:frozennotes/views/drawings/drawing_area.dart';

class CloudDrawing {
  final String documentId;
  final String ownerUserId;
  List<DrawingArea> drawingData = [];

  CloudDrawing({
    required this.documentId,
    required this.ownerUserId,
    required this.drawingData,
  });

  // give snapshot of clouddrawing
  CloudDrawing.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        drawingData = List<DrawingArea>.from(snapshot
            .data()[drawingDataFieldName]
            .map((map) => DrawingArea.fromMap(Map<String, dynamic>.from(map))));

  Map<String, dynamic> toMap() {
    return {
      ownerUserIdFieldName: ownerUserId,
      drawingDataFieldName: drawingData.map((area) => area.toMap()).toList(),
    };
  }
}
