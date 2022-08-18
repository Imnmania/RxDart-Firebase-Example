import 'package:flutter/material.dart';
import 'package:rx_dart_example_11_firebase/models/contact.dart';
import 'package:rx_dart_example_11_firebase/presentation/widgets/dialogs/delete_contact_dialog.dart';
import 'package:rx_dart_example_11_firebase/helpers/type_definitions.dart';

class ContactsListTile extends StatelessWidget {
  final Contact contact;
  final DeleteContactCallback deleteContact;

  const ContactsListTile({
    Key? key,
    required this.contact,
    required this.deleteContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.fullName),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          final shouldDelete = await showDeleteContactDialog(context);
          if (shouldDelete) {
            deleteContact(contact);
          }
        },
      ),
    );
  }
}
