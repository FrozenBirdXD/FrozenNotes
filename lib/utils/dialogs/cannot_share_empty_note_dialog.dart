import 'package:flutter/material.dart';
import 'package:frozennotes/utils/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'Opps! You cannot share an empty note.',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
