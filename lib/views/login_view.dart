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
  bool _passwordVisible = false;
  // for when user presses enter
  final _formKey = GlobalKey<FormState>();

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
              'Authentication error - Please try again.',
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36.0,
                  vertical: 48.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      const Text(
                        'Please log in to your acount to access your FrozenNotes Profile!',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      // email text field
                      TextFormField(
                        controller: _email,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.grey[250],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.blue[300]!,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          _submitFormLogin();
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      // password text field
                      TextFormField(
                        controller: _password,
                        obscureText: !_passwordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[250],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.blue[300]!,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          _submitFormLogin();
                        },
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      // login button
                      SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitFormLogin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                            textStyle: const TextStyle(fontSize: 18.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('Log In'),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      // Forgot password
                      SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(const AuthForgotPasswordEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[200],
                            textStyle: const TextStyle(fontSize: 18.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      // Go to register view button
                      SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(const AuthShouldRegisterEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[200],
                            textStyle: const TextStyle(fontSize: 18.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child:
                              const Text('Not registered yet? Register here!'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitFormLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // hide keyboard when user taps login or presses enter
      FocusScope.of(context).unfocus();
      // simulate tap on login button
      BlocProvider.of<AuthBloc>(context).add(
        AuthLoginEvent(
          _email.text,
          _password.text,
        ),
      );
    }
  }
}
