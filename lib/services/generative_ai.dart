import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../model/recipe.dart';
import '../sample_recipes.dart';

class GenerativeAIService {
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const _ingredientsPrompt = '''
    What are the ingredients you see in the image? Return your answer
    as a list of strings in JSON format. Output no other text. Only
    list ingredients that are part of recipes and can be used to make
    edible food. If there are no ingredients in the image, return an
    empty JSON body like "{}". Only add ingredients to the list if you
    are absolutely sure that they are ingredients for food.
  ''';

  final _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: _apiKey,
  );

  static final _instance = GenerativeAIService._();

  factory GenerativeAIService() {
    return _instance;
  }

  GenerativeAIService._();

  String _recipePrompt(List<String> ingredients, List<String> preferences) {
    return '''
      Generate a list of recipes using the given ingredients and dietary preferences.
      Return your output in JSON format. Output no other text. If you can't generate
      any recipes with the given constraints, output an empty JSON body ("{}"). Here
      is an example:
      EXAMPLE_BEGIN
      INPUT: Generate a list of recipes using ['peanut butter', 'chocolate chips', 'bread']
      and dietary preferences ['vegan']:
      OUTPUT: $sampleRecipes
      EXAMPLE_END
      Now, generate a list of recipes using $ingredients and dietary preferences
      $preferences.
    ''';
  }

  Future<List<String>?> generateIngredients(Uint8List bytes) async {
    final content = [
      Content.multi([
        TextPart(_ingredientsPrompt),
        DataPart('image/jpeg', bytes),
      ])
    ];
    final response = await _model.generateContent(content);
    if (response.text != null) {
      final Map<String, dynamic> decoded = jsonDecode(response.text!);
      if (decoded['ingredients'] is List) {
        return List<String>.from(decoded['ingredients']);
      }
    }
    return null;
  }

  Future<List<Recipe>?> generateRecipes(
    List<String> ingredients,
    List<String> preferences,
  ) async {
    final content = [Content.text(_recipePrompt(ingredients, preferences))];
    final response = await _model.generateContent(content);
    if (response.text != null) {
      final Map<String, dynamic> decoded = jsonDecode(response.text!);
      if (decoded['recipes'] is List) {
        List<Map<String, dynamic>> recipes = List.from(decoded['recipes']);
        return recipes.map(Recipe.fromJson).toList();
      }
    }
    return null;
  }
}
