import 'package:flutter/foundation.dart' show immutable;
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rx_dart_example_11_firebase/models/contact.dart';
import 'package:rxdart/rxdart.dart';

typedef _Snapshots = QuerySnapshot<Map<String, dynamic>>;
typedef _Documents = DocumentReference<Map<String, dynamic>>;

extension Unwrap<T> on Stream<T?> {
  Stream<T> unwrap() => switchMap((optional) async* {
        if (optional != null) {
          yield optional;
        }
      });
}

@immutable
class ContactsBloc {
  final Sink<String?> userId;
  final Sink<Contact> createContact;
  final Sink<Contact> deleteContact;
  final Stream<Iterable<Contact>> contacts;
  final StreamSubscription<void> _createContactSubscription;
  final StreamSubscription<void> _deleteContactSubscription;

  const ContactsBloc._({
    required this.userId,
    required this.createContact,
    required this.deleteContact,
    required this.contacts,
    required StreamSubscription<void> createContactSubscription,
    required StreamSubscription<void> deleteContactSubscription,
  })  : _createContactSubscription = createContactSubscription,
        _deleteContactSubscription = deleteContactSubscription;

  void dispose() {
    userId.close();
    createContact.close();
    deleteContact.close();
  }

  factory ContactsBloc() {
    final backend = FirebaseFirestore.instance;

    // user id
    final userId = BehaviorSubject<String?>();

    // upon changes to user id, retrieve our contacts
    final Stream<Iterable<Contact>> contacts =
        userId.switchMap<_Snapshots>((userId) {
      if (userId == null) {
        return const Stream<_Snapshots>.empty();
      } else {
        return backend.collection(userId).snapshots();
      }
    }).map<Iterable<Contact>>((snapshots) sync* {
      for (final doc in snapshots.docs) {
        yield Contact.fromJson(doc.data(), id: doc.id);
      }
    });

    // create contacts
    final createContactSubject = BehaviorSubject<Contact>();
    final StreamSubscription<void> createContactSubscription =
        createContactSubject.switchMap((Contact contactToCreate) {
      return userId.take(1).unwrap().asyncMap((userId) {
        backend.collection(userId).add(contactToCreate.toJson());
      });
    }).listen((event) {});

    // delete contacts
    final deleteContactSubject = BehaviorSubject<Contact>();
    final StreamSubscription<void> deleteContactSubscription =
        deleteContactSubject.switchMap((Contact contactToDelete) {
      return userId.take(1).unwrap().asyncMap((userId) {
        backend.collection(userId).doc(contactToDelete.id).delete();
      });
    }).listen((event) {});

    // create contacts bloc
    return ContactsBloc._(
      userId: userId,
      createContact: createContactSubject,
      deleteContact: deleteContactSubject,
      contacts: contacts,
      createContactSubscription: createContactSubscription,
      deleteContactSubscription: deleteContactSubscription,
    );
  }
}

// void testIt() {
//   final myStream = Stream.periodic(const Duration(seconds: 1), (i) => 1);
//   final mySubscription = myStream.listen((event) {});
// }

// Iterable<int> oneToThree() sync* {
//   yield 1;
//   yield 2;
//   yield 3;
// }

// Stream<int> oneToThree_() async* {
//   yield 1;
//   yield 2;
//   yield 3;
// }
