import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../helpers/alert.dart';
import '../model/recipe.dart';
import '../providers/ingredients.dart';
import '../providers/preferences.dart';
import '../providers/recipes.dart';
import '../providers/user.dart';
import '../services/generative_ai.dart';
import '../widgets/spinner.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  final _generativeAIService = GenerativeAIService();
  bool _loading = false;

  Future<void> _addRecipes(
    List<Recipe> originalRecipes,
    List<Recipe> newRecipes,
  ) async {
    try {
      final user = ref.read(userProvider);
      if (user case (AsyncData(:final value)) when value != null) {
        final originalRecipeNames =
            originalRecipes.map((recipe) => recipe.name).toList();
        final recipesToAdd = <Recipe>[];
        for (final recipe in newRecipes) {
          if (!originalRecipeNames.contains(recipe.name)) {
            recipesToAdd.add(recipe);
          }
        }
        final batch = FirebaseFirestore.instance.batch();
        for (final recipe in recipesToAdd) {
          final document = FirebaseFirestore.instance
              .collection('users')
              .doc(value.uid)
              .collection('recipes')
              .doc();
          batch.set(document, recipe.copyWith(id: document.id).toJson());
        }
        await batch.commit();
      } else if (mounted) {
        showErrorAlert(context, 'Failed to fetch recipe data');
      }
    } on FirebaseException catch (e) {
      if (mounted && e.message != null) {
        showErrorAlert(context, e.message!);
      }
    }
  }

  Future<void> _removeRecipe(List<Recipe> recipes, int index) async {
    try {
      final recipe = recipes[index];
      final user = ref.read(userProvider);
      if (user case AsyncData(:final value)
          when value != null && recipe.id != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.uid)
            .collection('recipes')
            .doc(recipe.id)
            .delete();
      }
    } on FirebaseException catch (e) {
      if (mounted && e.message != null) {
        showErrorAlert(context, e.message!);
      }
    }
  }

  Future<void> _generateRecipes(List<Recipe> originalRecipes) async {
    try {
      setState(() {
        _loading = true;
      });
      final ingredients = ref.read(ingredientsProvider);
      final preferences = ref.read(preferencesProvider);
      List<Recipe>? newRecipes;
      switch ((ingredients, preferences)) {
        case (
              AsyncData(value: final ingredientsValue),
              AsyncData(value: final preferencesValue)
            )
            when ingredientsValue != null && preferencesValue != null:
          newRecipes = await _generativeAIService.generateRecipes(
            ingredientsValue,
            preferencesValue,
          );
        case (AsyncData(value: final ingredientsValue), _)
            when ingredientsValue != null:
          newRecipes =
              await _generativeAIService.generateRecipes(ingredientsValue, []);
        case _:
          if (mounted) {
            showErrorAlert(context, 'There are no ingredients');
          }
      }
      if (newRecipes != null) {
        await _addRecipes(originalRecipes, newRecipes);
      } else if (mounted) {
        showErrorAlert(context, 'Failed to generate recipes');
      }
    } on GenerativeAIException catch (e) {
      if (mounted) {
        showErrorAlert(context, e.message);
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  List<Widget> _buildMainView(List<Recipe> recipes) {
    final themeData = Theme.of(context);
    return [
      ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: UniqueKey(),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {
                _removeRecipe(recipes, index);
              }),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    _removeRecipe(recipes, index);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(recipes[index].name),
                  onTap: () {
                    context.go('/recipes/${recipes[index].id}');
                  },
                ),
                const Divider(height: 0),
              ],
            ),
          );
        },
      ),
      Positioned(
        bottom: 24.0,
        right: 24.0,
        child: FloatingActionButton(
          onPressed: _loading
              ? null
              : () {
                  _generateRecipes(recipes);
                },
          backgroundColor: _loading
              ? Colors.grey[300]
              : themeData.floatingActionButtonTheme.backgroundColor,
          child: _loading ? const Spinner(size: 20.0) : const Icon(Icons.bolt),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipesProvider);
    return Stack(
      fit: StackFit.expand,
      children: (switch (recipes) {
        AsyncLoading() => [const Center(child: Spinner())],
        AsyncData(:final value) when value != null => _buildMainView(value),
        _ => _buildMainView([]),
      }),
    );
  }
}
