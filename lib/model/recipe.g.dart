// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      servings: (json['servings'] as num).toInt(),
      prepTime: json['prepTime'] as String,
      cookTime: json['cookTime'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'servings': instance.servings,
      'prepTime': instance.prepTime,
      'cookTime': instance.cookTime,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };

RecipeStep _$RecipeStepFromJson(Map<String, dynamic> json) => RecipeStep(
      number: (json['number'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$RecipeStepToJson(RecipeStep instance) =>
    <String, dynamic>{
      'number': instance.number,
      'description': instance.description,
    };
