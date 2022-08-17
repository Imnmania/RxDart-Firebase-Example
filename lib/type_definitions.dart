import 'package:flutter/material.dart';
import 'package:rx_dart_example_11_firebase/models/contact.dart';

typedef LogoutCallback = VoidCallback;
typedef GoBackCallback = VoidCallback;
typedef LoginCallback = void Function(
  String email,
  String password,
);
typedef RegisterCallback = void Function(
  String email,
  String password,
);
typedef CreateContactCallback = void Function(
  String firstName,
  String lastName,
  String phoneNumber,
);
typedef DeleteContactCallback = void Function(Contact contact);
typedef DeleteAccountCallback = VoidCallback;
