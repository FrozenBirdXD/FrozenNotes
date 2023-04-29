import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frozennotes/services/auth/auth_exceptions.dart';
import 'package:frozennotes/services/auth/bloc/auth_bloc.dart';
import 'package:frozennotes/utils/dialogs/error_dialog.dart';
import 'package:frozennotes/utils/dialogs/reset_password_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthForgotPasswordState) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showResetPasswordEmailSentDialog(context);
          }
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
                context, 'Invalid email - Please enter a valid email address.');
          } else if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context,
                'User not found - Please check if the email is correct or register a new account.');
          } else if (state.exception != null) {
            await showErrorDialog(context,
                'We could no process your request. Please try again in a moment.');
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          // Hide the keyboard when the user taps outside of the TextField
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: const Text('Forgot Password')),
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                const Text(
                  "If you've lost your password or wish to reset it, simply enter your email address and follow the directions in the email.",
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // email text field
                TextField(
                  controller: _controller,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email here',
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // send email button
                ElevatedButton(
                  onPressed: () async {
                    final email = _controller.text;

                    FocusScope.of(context).unfocus(); // hide keyboard
                    // login
                    BlocProvider.of<AuthBloc>(context).add(
                      AuthForgotPasswordEvent(email: email),
                    );
                  },
                  child: const Text('Send password reset link'),
                ),
                // Go to register view button
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(const AuthLogoutEvent());
                  },
                  child: const Text('Go back to login page'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
