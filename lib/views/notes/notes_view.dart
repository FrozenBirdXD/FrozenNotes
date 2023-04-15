import 'package:flutter/material.dart';
import 'package:frozennotes/constants/routes.dart';
import 'package:frozennotes/enums/menu_action.dart';
import 'package:frozennotes/services/auth/auth_service.dart';
import 'package:frozennotes/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;

  late final NotesService _notesService;

  // open db when notesView widget is inserted into widget tree for the first time
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  // close db when notesView widget is removed from widget tree
  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add new note',
          ),
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
                    // when stream does not contain any value -> no note
                    case ConnectionState.waiting:
                    // when at least one note has been returned by stream
                    case ConnectionState.active:
                      return const Text('No note has been created yet...');
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

Future<bool> showSignOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Sign out'),
          ),
        ],
      );
    },
  ).then(
    (value) => value ?? false,
  );
}
