import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frozennotes/services/auth/bloc/auth_bloc.dart';
import 'package:frozennotes/utils/dialogs/sign_out_dialog.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Profile'),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Options', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(
                  const AuthChangePasswordEvent(newPassword: null),
                );
              },
              child: const Text('Change Password'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final logout = await showSignOutDialog(context);
                if (logout) {
                  BlocProvider.of<AuthBloc>(context).add(
                    const AuthLogoutEvent(),
                  );
                }
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
