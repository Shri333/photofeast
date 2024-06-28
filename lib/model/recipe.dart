import 'package:json_annotation/json_annotation.dart';

import 'ingredient.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final String name;
  final String description;
  final int servings;
  final String prepTime;
  final String cookTime;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  const Recipe({
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
