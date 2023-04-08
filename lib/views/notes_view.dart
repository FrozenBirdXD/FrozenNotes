import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), 
        actions: [
          PopupMenuButton<MenuButtons>(
            onSelected: (value) async {
              switch (value) {
                case MenuButtons.logout:
                  final logout = await showSignOutDialog(context);
                  if (logout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login/', 
                    (_) => false);
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
          ),
        ],
      ),
      body: const Text('First note'),
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
    }
  ).then((value) => value ?? false);
}

enum MenuButtons { logout }