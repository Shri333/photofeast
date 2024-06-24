import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user.dart';

part 'ingredients.g.dart';

@riverpod
Stream<List<String>?> ingredients(
  IngredientsRef ref,
) async* {
  final user = ref.watch(userProvider);
  if (user case AsyncData(:final value) when value != null) {
    yield* FirebaseFirestore.instance
        .collection('ingredients')
        .doc(value.uid)
        .snapshots()
        .map((snapshot) => List<String>.from(snapshot.get('ingredients')));
  }
}
