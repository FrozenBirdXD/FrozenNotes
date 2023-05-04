// super class
class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNote extends CloudStorageException {}

class CouldNotGetAllNotes extends CloudStorageException {}

class CouldNotUpdateNote extends CloudStorageException {}

class CouldNotDeleteNote extends CloudStorageException {}


class CouldNotDeleteDrawing extends CloudStorageException {}

class CouldNotUpdateDrawing extends CloudStorageException {}

class CouldNotGetAllDrawings extends CloudStorageException {}
