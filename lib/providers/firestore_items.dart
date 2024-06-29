import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/firestore_items.dart';

part 'firestore_items.g.dart';

@riverpod
FirestoreItemsService firestoreItemsService(
  FirestoreItemsServiceRef ref,
  String key,
) {
  return FirestoreItemsService(ref: ref, key: key);
}
