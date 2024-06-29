import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user.dart';

part 'preferences.g.dart';

@riverpod
Stream<List<String>?> preferences(
  PreferencesRef ref,
) async* {
  final user = ref.watch(userProvider);
  if (user case AsyncData(:final value) when value != null) {
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(value.uid)
        .snapshots()
        .map((snapshot) => List<String>.from(snapshot.get('preferences')));
  }
}
