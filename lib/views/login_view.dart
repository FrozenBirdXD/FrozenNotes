import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frozennotes/services/auth/bloc/auth_bloc.dart';
import 'package:frozennotes/services/auth/auth_exceptions.dart';
import 'package:frozennotes/utils/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bloc listener for auth exceptions
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoggedOutState) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              'User not found - Please sign in or register a new account.',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              'Incorrect credentials - Please try again.',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'Invalid email - Please enter a valid email address.',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Authentication error',
            );
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          // Hide the keyboard when the user taps outside of the TextFields
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                // email text field
                TextField(
                  controller: _email,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email here',
                  ),
                ),
                // password text field
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password here',
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // login button   
                ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                      
                    // login
                    BlocProvider.of<AuthBloc>(context).add(
                      AuthLoginEvent(
                        email,
                        password,
                      ),
                    );
                    FocusScope.of(context).unfocus(); // hide keyboard
                  },
                  child: const Text('Login'),
                ),
                // Go to register view button
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(const AuthShouldRegisterEvent());
                  },
                  child: const Text('Not registered yet? Register here!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
