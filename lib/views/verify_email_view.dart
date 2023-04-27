import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frozennotes/services/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
            "We've sent you a verification email. Please open it to verify your account.",
          ),
          const Text(
            "If you haven't received a verification yet, press the button below:",
          ),
          // send verification email button
          TextButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context)
                  .add(const AuthSendVerificationEmailEvent());
            },
            child: const Text('Resend verification email'),
          ),
          // go to login view button
          TextButton(
            onPressed: () async {
              BlocProvider.of<AuthBloc>(context).add(const AuthLogoutEvent());
            },
            child: const Text('Go to login page'),
          ),
        ],
      ),
    );
  }
}
