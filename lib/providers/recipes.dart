import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/recipe.dart';
import 'user.dart';

part 'recipes.g.dart';

@riverpod
Stream<List<Recipe>?> recipes(RecipesRef ref) async* {
  final user = ref.watch(userProvider);
  if (user case AsyncData(:final value) when value != null) {
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(value.uid)
        .collection('recipes')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList(),
        );
  }
}
