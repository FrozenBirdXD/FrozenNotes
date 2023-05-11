import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frozennotes/services/auth/bloc/auth_bloc.dart';
import 'package:frozennotes/services/auth/firebase_auth_provider.dart';
import 'package:frozennotes/utils/constants/routes.dart';
import 'package:frozennotes/utils/loading/loading_screen.dart';
import 'package:frozennotes/views/drawings/create_update_drawing_view.dart';
import 'package:frozennotes/views/drawings/drawings_view.dart';
import 'package:frozennotes/views/forgot_password_view.dart';
import 'package:frozennotes/views/login_view.dart';
import 'package:frozennotes/views/notes/create_update_note_view.dart.dart';
import 'package:frozennotes/views/notes/notes_view.dart';
import 'package:frozennotes/views/profile/change_password_view.dart';
import 'package:frozennotes/views/profile/profile_view.dart';
import 'package:frozennotes/views/register_view.dart';
import 'package:frozennotes/views/verify_email_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // catch errors thrown in flutter framework
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'FrozenNotes',
      theme: ThemeData(
        primarySwatch: getMaterialColor(Colors.lightBlue.shade200),
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        changePasswordRoute: (context) => const ChangePasswordView(),
        notesRoute: (context) => const NotesView(),
        createOrUpdateDrawingRoute:(context) => const CreateUpdateDrawingView(),
      },
    ),
  );
}

MaterialColor getMaterialColor(Color color) {
  final Map<int, Color> shades = {
    50: const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };
  return MaterialColor(color.value, shades);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // index of navigator selection
  int _currentIndex = 0;
  // list of views for navigator
  final List<Widget> _views = [
    const NotesView(),
    const DrawingsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    // initialize
    BlocProvider.of<AuthBloc>(context).add(const AuthInitEvent());
    // check state of builder all the time ---> also checks if state has isLoading true
    // if state change in e.g. login view, this is called
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? "In a moment, we'll be ready.",
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthLoggedInState) {
          // return correct view
          return Scaffold(
            body: _views[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.notes),
                  label: 'Notes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.brush),
                  label: 'Drawables',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        } else if (state is AuthNeedVerificationState) {
          return const VerifyEmailView();
        } else if (state is AuthLoggedOutState) {
          return const LoginView();
        } else if (state is AuthRegisteringState) {
          return const RegisterView();
        } else if (state is AuthForgotPasswordState) {
          return const ForgotPasswordView();
        } else if (state is AuthChangePasswordState) {
          return const ChangePasswordView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
