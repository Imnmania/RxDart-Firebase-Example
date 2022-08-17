import 'package:flutter/material.dart';
import 'package:rx_dart_example_11_firebase/presentation/screens/contacts_list_tile.dart';
import 'package:rx_dart_example_11_firebase/presentation/widgets/popup_menu/main_popup_menu_button.dart';
import 'package:rx_dart_example_11_firebase/type_definitions.dart';

import '../../models/contact.dart';

class ContactsListScreen extends StatelessWidget {
  final DeleteContactCallback deleteContact;
  final LogoutCallback logout;
  final DeleteAccountCallback deleteAccount;
  final VoidCallback createNewContact;
  final Stream<Iterable<Contact>> contacts;

  const ContactsListScreen({
    Key? key,
    required this.deleteContact,
    required this.logout,
    required this.deleteAccount,
    required this.createNewContact,
    required this.contacts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
        actions: [
          MainPopupMenuButton(
            logout: logout,
            deleteAccount: deleteAccount,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewContact,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<Iterable<Contact>>(
        stream: contacts,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              final contacts_ = snapshot.requireData;
              return ListView.builder(
                itemCount: contacts_.length,
                itemBuilder: (context, index) {
                  final contact = contacts_.elementAt(index);
                  return ContactsListTile(
                    contact: contact,
                    deleteContact: deleteContact,
                  );
                },
              );
          }
        },
      ),
    );
  }
}
