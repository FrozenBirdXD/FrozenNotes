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
    return notes.snapshots().map(
      (event) {
        return event.docs.map(
          (doc) {
            return CloudNote.fromSnapshot(doc);
          },
        ).where(
          (note) {
            return note.ownerUserId == ownerUserId;
          },
        );
      },
    );
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

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          // get notes where userid == owner
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
        // map the future to CloudNote
        (value) {
          return value.docs.map(
            (doc) {
              return CloudNote.fromSnapshot(doc);
            },
          );
        },
      );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }
}
