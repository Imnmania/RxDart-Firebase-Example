import 'package:flutter/material.dart';
import 'package:rx_dart_example_11_firebase/presentation/widgets/dialogs/generic_dialog.dart';

Future<bool> showDeleteContactDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Delete contact',
      content:
          'Are you sure you want to delete your contact? You cannot undo this operation!',
      optionBuilder: () => {
            'CANCEL': false,
            'DELETE': true,
          }).then((value) => value ?? false);
}
