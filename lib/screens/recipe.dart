import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/ingredient.dart';
import '../model/recipe.dart';
import '../providers/recipe.dart';
import '../widgets/page_not_found.dart';
import '../widgets/scroll.dart';
import '../widgets/spinner.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key, required this.recipeId});

  final String? recipeId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  Widget _buildRecipeView(Recipe recipe) {
    final themeData = Theme.of(context);
    return Scroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4.0),
          TextButton.icon(
            onPressed: () {
              context.go('/recipes');
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('back'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: themeData.textTheme.headlineLarge,
                ),
                const SizedBox(height: 4.0),
                Text(recipe.description),
                const SizedBox(height: 4.0),
                Text('Servings: ${recipe.servings}'),
                Text('Prep Time: ${recipe.prepTime}'),
                Text('Cook Time: ${recipe.cookTime}'),
                const SizedBox(height: 8.0),
                Text(
                  'Ingredients',
                  style: themeData.textTheme.headlineMedium,
                ),
                for (final Ingredient(:name, :quantity) in recipe.ingredients)
                  Text('- $name: $quantity'),
                const SizedBox(height: 8.0),
                Text(
                  'Steps',
                  style: themeData.textTheme.headlineMedium,
                ),
                for (final RecipeStep(:number, :description) in recipe.steps)
                  Text('$number. $description'),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
      AsyncData(:final value) when value != null => _buildRecipeView(value),
      _ => const PageNotFoundWidget(message: 'Recipe not found')
    };
  }
}
