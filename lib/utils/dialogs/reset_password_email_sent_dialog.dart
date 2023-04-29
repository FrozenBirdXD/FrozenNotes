import 'package:flutter/material.dart';
import 'package:frozennotes/utils/dialogs/generic_dialog.dart';

Future<void> showResetPasswordEmailSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset Email Sent',
    content: 'An email has been sent to your email address. Follow the directions in the email to reset your password.',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
