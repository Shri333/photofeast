import 'package:json_annotation/json_annotation.dart';

import 'ingredient.dart';

part 'recipe.g.dart';

@JsonSerializable(explicitToJson: true)
class Recipe {
  final String? id;
  final String name;
  final String description;
  final int servings;
  final String prepTime;
  final String cookTime;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.servings,
    required this.prepTime,
    required this.cookTime,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  Recipe copyWith({required String id}) {
    return Recipe(
      id: id,
      name: name,
      description: description,
      servings: servings,
      prepTime: prepTime,
      cookTime: cookTime,
      ingredients: ingredients,
      steps: steps,
    );
  }
}

@JsonSerializable()
class RecipeStep {
  final int number;
  final String description;

  const RecipeStep({
    required this.number,
    required this.description,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) =>
      _$RecipeStepFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeStepToJson(this);
}
