import 'package:flutter/material.dart';
import 'package:frozennotes/constants/routes.dart';
import 'package:frozennotes/enums/menu_action.dart';
import 'package:frozennotes/services/auth/auth_service.dart';
import 'package:frozennotes/services/crud/notes_service.dart';
import 'package:frozennotes/utils/dialogs/sign_out_dialog.dart';
import 'package:frozennotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;

  late final NotesService _notesService;

  // get singleton when notesView widget is inserted into widget tree for the first time
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          // add note button
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add new note',
          ),
          // menu button
          PopupMenuButton<MenuButtons>(
            onSelected: (value) async {
              switch (value) {
                case MenuButtons.logout:
                  final logout = await showSignOutDialog(context);
                  if (logout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuButtons>(
                  value: MenuButtons.logout,
                  child: Text('Sign out'),
                ),
              ];
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (
          context,
          snapshot,
        ) {
          switch (snapshot.connectionState) {
            // when user is created or retrieved
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (
                  context,
                  snapshot,
                ) {
                  switch (snapshot.connectionState) {
                    // when stream does not contain any value
                    case ConnectionState.waiting:
                    // when at least one note has been returned by stream
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        if (allNotes.isEmpty) {
                          return const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Ready to start taking notes? \nCreate your first one now!',
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        } else {
                          // list of all notes
                          return NotesListView(
                            notes: allNotes,
                            // delete button
                            onDeleteNote: (note) async {
                              await _notesService.deleteNote(id: note.id);
                            },
                            // tap on note
                            onTap: (note) {
                              Navigator.of(context).pushNamed(
                                createOrUpdateNoteRoute,
                                arguments: note,
                              );
                            },
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },
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
