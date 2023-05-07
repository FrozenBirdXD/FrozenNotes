import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frozennotes/services/cloud/cloud_drawing.dart';
import 'package:frozennotes/services/cloud/cloud_storage_constants.dart';
import 'package:frozennotes/services/cloud/cloud_storage_exceptions.dart';

class CloudDrawingStorageService {
  // get all drawings from firebase
  final drawings = FirebaseFirestore.instance.collection('drawings');

  // singleton for storage
  static final CloudDrawingStorageService _shared =
      CloudDrawingStorageService._sharedInstance();
  CloudDrawingStorageService._sharedInstance();
  factory CloudDrawingStorageService() => _shared;

  Stream<Iterable<CloudDrawing>> allDrawings({required String ownerUserId}) {
    try {
      final drawing = drawings
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .snapshots()
          .map((event) =>
              event.docs.map((doc) => CloudDrawing.fromSnapshot(doc)));

      return drawing;
    } catch (e) {
      throw CouldNotGetAllDrawings();
    }
  }

  Future<void> updateDrawing({
    required String documentId,
    required List<Map<String, dynamic>> drawingData,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      await drawings.doc(documentId).update({
        drawingDataFieldName: drawingData,
        metadataFieldName: metadata,
      });
    } catch (e) {
      throw CouldNotUpdateDrawing();
    }
  }

  Future<void> deleteDrawing({required String documentId}) async {
    try {
      await drawings.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteDrawing();
    }
  }

  Future<CloudDrawing> createNewDrawing({required String ownerUserId}) async {
    final doc = await drawings.add({
      ownerUserIdFieldName: ownerUserId,
      drawingDataFieldName: [],
      metadataFieldName: {},
    });
    final drawing = await doc.get();
    return CloudDrawing(
      documentId: drawing.id,
      ownerUserId: ownerUserId,
      drawingData: const [],
    );
  }
}
