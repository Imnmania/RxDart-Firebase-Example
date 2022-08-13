import 'package:flutter/material.dart';
import 'package:rx_dart_example_11_firebase/blocs/auth_bloc/auth_error.dart';
import 'package:rx_dart_example_11_firebase/presentation/widgets/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionBuilder: () => {'OK': true},
  );
}
