import 'package:flutter/material.dart';
import 'package:rx_dart_example_11_firebase/presentation/widgets/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Log out',
      content: 'Are you sure you want to log out?',
      optionBuilder: () => {
            'CANCEL': false,
            'LOG OUT': true,
          }).then((value) => value ?? false);
}
