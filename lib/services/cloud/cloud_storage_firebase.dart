import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frozennotes/services/cloud/cloud_note.dart';
import 'package:frozennotes/services/cloud/cloud_storage_constants.dart';
import 'package:frozennotes/services/cloud/cloud_storage_exceptions.dart';

class CloudStorageFirebase {
  // get all notes from firebase
  final notes = FirebaseFirestore.instance.collection('notes');

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

  // singleton for storage
  static final CloudStorageFirebase _shared =
      CloudStorageFirebase._sharedInstance();
  CloudStorageFirebase._sharedInstance();
  factory CloudStorageFirebase() => _shared;

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
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
              return CloudNote(
                documentId: doc.id,
                ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                text: doc.data()[textFieldName] as String,
              );
            },
          );
        },
      );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }
}
