import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recipe.dart';
import '../widgets/page_not_found.dart';
import '../widgets/spinner.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key, required this.recipeId});

  final String? recipeId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.recipeId == null) {
      return const PageNotFoundWidget(message: 'Recipe not found');
    }
    final recipe = ref.watch(recipeProvider(widget.recipeId!));
    return switch (recipe) {
      AsyncLoading() => const Center(
          child: Spinner(),
        ),
      AsyncData(:final value) when value != null => Center(
          child: Text(value.name),
        ),
      _ => const PageNotFoundWidget(message: 'Recipe not found')
    };
  }
}
