import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/firestore_items.dart';
import '../providers/user.dart';

class FirestoreItemsService {
  FirestoreItemsService({required this.ref, required this.key});

  final FirestoreItemsServiceRef ref;
  final String key;

  User? _getUser() {
    final user = ref.read(userProvider);
    if (user case AsyncData(:final value) when value != null) {
      return value;
    }
    return null;
  }

  Future<bool> _setItems(List<String> items) async {
    final user = _getUser();
    if (user == null) {
      return false;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({key: items}, SetOptions(merge: true));
    return true;
  }

  Future<bool> addItems(List<String> oldItems, List<String> newItems) async {
    final items = List<String>.from(
      Set<String>.from(oldItems).union(
        Set<String>.from(newItems),
      ),
    );
    return _setItems(items);
  }

  Future<bool> addItem(List<String> items, String item) async {
    if (items.contains(item)) {
      return false;
    }
    return _setItems(items + [item]);
  }

  Future<bool> removeItem(List<String> items, int index) async {
    final itemsCopy = List<String>.from(items);
    itemsCopy.removeAt(index);
    return _setItems(itemsCopy);
  }
}
