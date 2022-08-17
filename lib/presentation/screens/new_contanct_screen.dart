import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rx_dart_example_11_firebase/helpers/if_debugging.dart';
import 'package:rx_dart_example_11_firebase/type_definitions.dart';

class NewContactScreen extends HookWidget {
  final CreateContactCallback createContact;
  final GoBackCallback goBack;

  const NewContactScreen({
    required this.createContact,
    required this.goBack,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstNameController =
        useTextEditingController(text: 'Niloy'.ifDebugging);
    final lastNameController =
        useTextEditingController(text: 'Biswas'.ifDebugging);
    final phoneNumberController =
        useTextEditingController(text: '+8801823282111'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: goBack,
        ),
        title: const Text('Create New Contact'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  hintText: 'First Name...',
                ),
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  hintText: 'Last Name...',
                ),
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number...',
                ),
                keyboardType: TextInputType.phone,
              ),
              TextButton(
                child: const Text('Save Contact'),
                onPressed: () {
                  final firstName = firstNameController.text;
                  final lastName = lastNameController.text;
                  final phoneNumber = phoneNumberController.text;
                  createContact(firstName, lastName, phoneNumber);
                  goBack();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
