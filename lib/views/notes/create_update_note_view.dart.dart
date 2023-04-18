import 'package:flutter/material.dart';
import 'package:frozennotes/services/auth/auth_service.dart';
import 'package:frozennotes/services/crud/notes_service.dart';
import 'package:frozennotes/utils/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  // current note
  DatabaseNote? _note;
  // current notesservice
  late final NotesService _notesService;
  late final TextEditingController _textController;

  Future<DatabaseNote> createOrGetNote(BuildContext context) async {
    // if widget passed args of type DatabaseNote
    final widgetNote = context.getArgument<DatabaseNote>();
    // if note update
    if (widgetNote != null) {
      _note = widgetNote;
      // set text of the note to the text of the given note
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    // if note addition
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;

    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // singleton
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createOrGetNote(context),
        builder: (
          context,
          snapshot,
        ) {
          switch (snapshot.connectionState) {
            // when new note has been created
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                // enable multiline textfield
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Write your note here...',
                ),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
