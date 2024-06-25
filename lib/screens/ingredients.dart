import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/alert.dart';
import '../providers/ingredients.dart';
import '../providers/user.dart';
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
  final _ingredientController = TextEditingController();

  final Map<ImageSource, bool> _loading = {
    ImageSource.camera: false,
    ImageSource.gallery: false
  };

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isAndroid) {
      _loading[ImageSource.camera] = _loading[ImageSource.gallery] = true;
      _getLostData();
    }
  }

  Future<void> _getLostData() async {
    final image = await _imageService.getLostData();
    if (image != null) {
      await _generateIngredients(image);
    }
    setState(() {
      _loading[ImageSource.camera] = _loading[ImageSource.gallery] = false;
    });
  }

  Future<void> _setIngredients(List<String> ingredients) async {
    try {
      final user = ref.read(userProvider);
      if (user case AsyncData(:final value) when value != null) {
        await FirebaseFirestore.instance
            .collection('ingredients')
            .doc(value.uid)
            .set({'ingredients': ingredients});
      }
    } on FirebaseException catch (e) {
      if (mounted && e.message != null) {
        showErrorAlert(context, e.message!);
      }
    }
  }

  void _addIngredients(
    List<String> oldIngredients,
    List<String> newIngredients,
  ) {
    final ingredients = List<String>.from(
      Set<String>.from(oldIngredients).union(
        Set<String>.from(newIngredients),
      ),
    );
    _setIngredients(ingredients);
  }

  void _addIngredient(List<String> ingredients, String ingredient) {
    if (ingredient.isEmpty) {
      return;
    }
    if (ingredients.contains(ingredient)) {
      showErrorAlert(context, '$ingredient already exists');
      return;
    }
    _setIngredients(ingredients + [ingredient]);
  }

  void _deleteIngredient(List<String> ingredients, int index) {
    ingredients.removeAt(index);
    _setIngredients(ingredients);
  }

  Future<void> _generateIngredients(Uint8List image) async {
    try {
      final oldIngredients = ref.read(ingredientsProvider);
      final newIngredients =
          await _generativeAIService.generateIngredients(image);
      if (oldIngredients case AsyncData(:final value)
          when value != null && newIngredients != null) {
        _addIngredients(value, newIngredients);
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
        _loading[source] = true;
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
        _loading[source] = false;
      });
    }
  }

  Future<void> _pickFromCamera() async {
    _pickImage(ImageSource.camera);
  }

  Future<void> _pickFromGallery() async {
    _pickImage(ImageSource.gallery);
  }

  Slidable _buildIngredient(List<String> ingredients, int index) {
    return Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          _deleteIngredient(ingredients, index);
        }),
        children: [
          SlidableAction(
            onPressed: (context) {
              _deleteIngredient(ingredients, index);
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
            title: Text(ingredients[index]),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }

  TextField _buildIngredientTextField(List<String> ingredients) {
    return TextField(
      controller: _ingredientController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16.0),
        hintText: 'add new ingredient',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.grey[500],
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
      onSubmitted: (value) {
        final ingredient = value.trim().toLowerCase();
        _addIngredient(ingredients, ingredient);
        _ingredientController.clear();
      },
    );
  }

  ListView _buildIngredients(List<String> ingredients) {
    return ListView.builder(
      itemCount: ingredients.length + 1,
      itemBuilder: (context, index) => index == ingredients.length
          ? _buildIngredientTextField(ingredients)
          : _buildIngredient(ingredients, index),
    );
  }

  Column _buildCameraButtons() {
    final themeData = Theme.of(context);
    return Column(
      children: [
        FloatingActionButton(
          heroTag: UniqueKey(),
          onPressed: _loading[ImageSource.gallery]! ? null : _pickFromGallery,
          backgroundColor: _loading[ImageSource.gallery]!
              ? Colors.grey[300]
              : themeData.floatingActionButtonTheme.backgroundColor,
          child: _loading[ImageSource.gallery]!
              ? const Spinner(size: 20.0)
              : const Icon(Icons.photo),
        ),
        if (!kIsWeb)
          const SizedBox(
            height: 16.0,
          ),
        if (!kIsWeb)
          FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: _loading[ImageSource.camera]! ? null : _pickFromCamera,
            backgroundColor: _loading[ImageSource.camera]!
                ? Colors.grey[300]
                : themeData.floatingActionButtonTheme.backgroundColor,
            child: _loading[ImageSource.camera]!
                ? const Spinner(size: 20.0)
                : const Icon(Icons.photo_camera),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = ref.watch(ingredientsProvider);
    return Stack(
      fit: StackFit.expand,
      children: [
        (switch (ingredients) {
          AsyncData(:final value) when value != null =>
            _buildIngredients(value),
          AsyncLoading() => const Center(child: Spinner()),
          _ =>
            const Center(child: Text('There was an error fetching ingredients'))
        }),
        Positioned(
          bottom: 24.0,
          right: 24.0,
          child: _buildCameraButtons(),
        )
      ],
    );
  }
}
