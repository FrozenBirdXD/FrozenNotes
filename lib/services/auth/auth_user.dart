import 'package:firebase_auth/firebase_auth.dart' as firebaseauth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  const AuthUser({
    required this.isEmailVerified,
    required this.email,
  });

  factory AuthUser.fromFirebase(firebaseauth.User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        email: user.email,
      );
}
