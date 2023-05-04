import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frozennotes/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudDrawing {
  final String documentId;
  final String ownerUserId;
  final List<Map<String, dynamic>> drawingData;
  final Map<String, dynamic> metadata;

  const CloudDrawing({
    required this.documentId,
    required this.ownerUserId,
    required this.drawingData,
    required this.metadata,
  });

  // give snapshot of clouddrawing
  CloudDrawing.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        drawingData = List<Map<String, dynamic>>.from(
            snapshot.data()[drawingDataFieldName]),
        metadata =
            Map<String, dynamic>.from(snapshot.data()[metadataFieldName]);

  // convert clouddrawing to map
  Map<String, dynamic> toMap() {
    return {
      ownerUserIdFieldName: ownerUserId,
      drawingDataFieldName: drawingData,
      metadataFieldName: metadata,
    };
  }
}
