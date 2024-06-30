import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/recipe.dart';
import 'user.dart';

part 'recipe.g.dart';

@riverpod
Stream<Recipe?> recipe(RecipeRef ref, String id) async* {
  final user = ref.watch(userProvider);
  if (user case AsyncData(:final value) when value != null) {
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(value.uid)
        .collection('recipes')
        .doc(id)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      return data != null ? Recipe.fromJson(data) : null;
    });
  }
}
