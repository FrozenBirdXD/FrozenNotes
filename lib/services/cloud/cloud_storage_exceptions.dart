// super class
class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotUpdateNote extends CloudStorageException {}

class CouldNoteDeleteNote extends CloudStorageException {}