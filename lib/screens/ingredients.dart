import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofeast/helpers/alert.dart';
import 'package:photofeast/widgets/spinner.dart';

class IngredientsScreen extends ConsumerStatefulWidget {
  const IngredientsScreen({super.key});

  @override
  ConsumerState<IngredientsScreen> createState() => _IngredilentsScreenState();
}

class _IngredilentsScreenState extends ConsumerState<IngredientsScreen> {
  static const _apiKey = '';

  static const _prompt = '''
  What are the ingredients you see in the image? Return your answer
  as a list of strings in JSON format. Output no other text. Only
  list ingredients that are part of recipes and can be used to make
  edible food. If there are no ingredients in the image, return an
  empty JSON body like "{}". Only add ingredients to the list if you
  are absolutely sure that they are ingredients for food.
  ''';

  final _imagePicker = ImagePicker();
  final _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: _apiKey,
  );

  bool _loading = false;
  List<String> _ingredients = [];

  Future<void> generateIngredients(XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      final content = [
        Content.multi([
          TextPart(_prompt),
          DataPart('image/jpeg', bytes),
        ])
      ];
      final response = await _model.generateContent(content);
      if (response.text == null) {
        if (mounted) {
          showErrorAlert(context, 'Failed to generate ingredients');
        }
        return;
      }
      final Map<String, dynamic> decoded = jsonDecode(response.text!);
      if (decoded.containsKey("ingredients") &&
          decoded['ingredients'] is List) {
        setState(() {
          _ingredients = List<String>.from(decoded['ingredients']);
        });
      } else if (mounted) {
        showErrorAlert(context, 'Failed to find ingredients in image');
      }
    } on GenerativeAIException {
      if (mounted) {
        showErrorAlert(context, 'Failed to generate ingredients');
      }
    }
  }

  Future<void> fromCamera() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image == null) {
        if (mounted) {
          showErrorAlert(context, 'Failed to retrieve photo');
        }
        return;
      }
      setState(() {
        _loading = true;
      });
      await generateIngredients(image);
    } on PlatformException {
      if (mounted) {
        showErrorAlert(context, 'Failed to access camera');
      }
    } catch (e) {
      if (mounted) {
        showErrorAlert(context);
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        ListView.builder(
          itemCount: _ingredients.length,
          itemBuilder: (context, index) => Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
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
                  title: Text(_ingredients[index]),
                ),
                const Divider(height: 0),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 24.0,
          right: 24.0,
          child: FloatingActionButton(
            onPressed: _loading ? null : fromCamera,
            backgroundColor: _loading
                ? Colors.grey[300]
                : themeData.floatingActionButtonTheme.backgroundColor,
            child: _loading
                ? const Spinner(size: 20.0)
                : const Icon(Icons.photo_camera),
          ),
        )
      ],
    );
  }
}
