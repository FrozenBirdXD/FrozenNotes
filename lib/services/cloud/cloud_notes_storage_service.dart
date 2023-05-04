import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frozennotes/services/cloud/cloud_note.dart';
import 'package:frozennotes/services/cloud/cloud_storage_constants.dart';
import 'package:frozennotes/services/cloud/cloud_storage_exceptions.dart';

class CloudStorageFirebaseService {
  // get all notes from firebase
  final notes = FirebaseFirestore.instance.collection('notes');

  // singleton for storage
  static final CloudStorageFirebaseService _shared =
      CloudStorageFirebaseService._sharedInstance();
  CloudStorageFirebaseService._sharedInstance();
  factory CloudStorageFirebaseService() => _shared;

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNote();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNoteDeleteNote();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final doc = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final note = await doc.get();
    return CloudNote(
      documentId: note.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }
}
