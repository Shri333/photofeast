import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

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
}
