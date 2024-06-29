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
import '../providers/firestore_items.dart';
import '../providers/ingredients.dart';
import '../services/firestore_items.dart';
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
  final _loading = <ImageSource, bool>{
    ImageSource.camera: false,
    ImageSource.gallery: false
  };

  late final FirestoreItemsService _ingredientsService;

  @override
  void initState() {
    super.initState();
    _ingredientsService = ref.read(
      firestoreItemsServiceProvider('ingredients'),
    );
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

  Future<bool> _withFirebaseErrorHandling(
    Future<bool> Function() callback,
  ) async {
    try {
      return await callback();
    } on FirebaseException catch (e) {
      if (mounted && e.message != null) {
        showErrorAlert(context, e.message!);
      }
    }
    return false;
  }

  void _addIngredient(List<String> ingredients, String ingredient) {
    if (ingredient.isEmpty) {
      return;
    }
    _withFirebaseErrorHandling(() async {
      final added = await _ingredientsService.addItem(
        ingredients,
        ingredient,
      );
      if (!added && mounted) {
        showErrorAlert(context, '$ingredient already exists');
      }
      return added;
    });
  }

  void _removeIngredient(List<String> ingredients, int index) {
    _withFirebaseErrorHandling(
      () => _ingredientsService.removeItem(ingredients, index),
    );
  }

  Future<void> _generateIngredients(Uint8List image) async {
    try {
      final oldIngredients = ref.read(ingredientsProvider);
      final newIngredients =
          await _generativeAIService.generateIngredients(image);
      if (oldIngredients case AsyncData(:final value)
          when value != null && newIngredients != null) {
        _withFirebaseErrorHandling(
          () => _ingredientsService.addItems(value, newIngredients),
        );
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
          _removeIngredient(ingredients, index);
        }),
        children: [
          SlidableAction(
            onPressed: (context) {
              _removeIngredient(ingredients, index);
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
          AsyncLoading() => const Center(child: Spinner()),
          AsyncData(:final value) when value != null =>
            _buildIngredients(value),
          _ => _buildIngredients([]),
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
