import 'package:firebase_auth/firebase_auth.dart' as firebaseauth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebase(firebaseauth.User user) => AuthUser(isEmailVerified: user.emailVerified);
}