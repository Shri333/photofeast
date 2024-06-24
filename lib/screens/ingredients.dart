import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/alert.dart';
import '../services/generative_ai.dart';
import '../services/image.dart';
import '../widgets/spinner.dart';

class IngredientsScreen extends ConsumerStatefulWidget {
  const IngredientsScreen({super.key});

  @override
  ConsumerState<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends ConsumerState<IngredientsScreen> {
  final _imageService = ImageService();
  final _generativeAIService = GenerativeAIService();

  bool _loading = false;
  List<String> _ingredients = [];

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _loading = true;
      _getLostData();
    }
  }

  Future<void> _getLostData() async {
    final image = await _imageService.getLostData();
    if (image != null) {
      await _generateIngredients(image);
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _generateIngredients(Uint8List image) async {
    try {
      final ingredients = await _generativeAIService.generateIngredients(image);
      if (ingredients != null) {
        setState(() {
          _ingredients = ingredients;
        });
      } else if (mounted) {
        showErrorAlert(context, 'Failed to find ingredients in image');
      }
    } on GenerativeAIException catch (e) {
      if (mounted) {
        showErrorAlert(context, e.message);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imageService.pickImage(source);
      if (image == null) {
        return;
      }
      setState(() {
        _loading = true;
      });
      await _generateIngredients(image);
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

  Future<void> _pickFromCamera() async {
    _pickImage(ImageSource.camera);
  }

  Future<void> _pickFromGallery() async {
    _pickImage(ImageSource.gallery);
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
            onPressed: _loading ? null : _pickFromCamera,
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
