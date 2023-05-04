import 'package:flutter/material.dart';
import 'package:frozennotes/services/cloud/cloud_note.dart';
import 'package:frozennotes/services/cloud/cloud_notes_storage_service.dart';
import 'package:frozennotes/utils/constants/routes.dart';
import 'package:frozennotes/services/auth/auth_service.dart';
import 'package:frozennotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  //current user id
  String get userId => AuthService.firebase().currentUser!.id;

  late final CloudStorageFirebaseService _notesService;

  // get singleton when notesView widget is inserted into widget tree for the first time
  @override
  void initState() {
    _notesService = CloudStorageFirebaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        centerTitle: true,
        // actions: [
        //   // add note button
        //   IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
        //     },
        //     icon: const Icon(Icons.add),
        //     tooltip: 'Add new note',
        //   ),
        //   // menu button
        //   PopupMenuButton<MenuButtons>(
        //     onSelected: (value) async {
        //       switch (value) {
        //         // logout button
        //         case MenuButtons.logout:
        //           final logout = await showSignOutDialog(context);
        //           if (logout) {
        //             BlocProvider.of<AuthBloc>(context).add(
        //               const AuthLogoutEvent(),
        //             );
        //           }
        //           break;
        //       }
        //     },
        //     itemBuilder: (context) {
        //       return [
        //         const PopupMenuItem<MenuButtons>(
        //           value: MenuButtons.logout,
        //           child: Text('Sign out'),
        //         ),
        //       ];
        //     },
        //     tooltip: 'Settings',
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
        },
        backgroundColor: Colors.lightBlue.shade200,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (
            context,
            snapshot,
          ) {
            switch (snapshot.connectionState) {
              // when stream does not contain any value
              case ConnectionState.waiting:
                // when at least one note has been returned by stream
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  if (allNotes.isEmpty) {
                    return Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          children: const [
                            Text(
                              'Ready to start taking notes?',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Create your first one now!',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // list of all notes
                    return NotesListView(
                      notes: allNotes,
                      // delete button
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(
                            documentId: note.documentId);
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
        ),
      ),
    );
  }
}
