// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recipeHash() => r'e3b67dc007d0e9ac3bc581b3ed8b7d6355f1f6b2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recipe].
@ProviderFor(recipe)
const recipeProvider = RecipeFamily();

/// See also [recipe].
class RecipeFamily extends Family<AsyncValue<Recipe?>> {
  /// See also [recipe].
  const RecipeFamily();

  /// See also [recipe].
  RecipeProvider call(
    String id,
  ) {
    return RecipeProvider(
      id,
    );
  }

  @override
  RecipeProvider getProviderOverride(
    covariant RecipeProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recipeProvider';
}

/// See also [recipe].
class RecipeProvider extends AutoDisposeStreamProvider<Recipe?> {
  /// See also [recipe].
  RecipeProvider(
    String id,
  ) : this._internal(
          (ref) => recipe(
            ref as RecipeRef,
            id,
          ),
          from: recipeProvider,
          name: r'recipeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recipeHash,
          dependencies: RecipeFamily._dependencies,
          allTransitiveDependencies: RecipeFamily._allTransitiveDependencies,
          id: id,
        );

  RecipeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<Recipe?> Function(RecipeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecipeProvider._internal(
        (ref) => create(ref as RecipeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Recipe?> createElement() {
    return _RecipeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RecipeRef on AutoDisposeStreamProviderRef<Recipe?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _RecipeProviderElement extends AutoDisposeStreamProviderElement<Recipe?>
    with RecipeRef {
  _RecipeProviderElement(super.provider);

  @override
  String get id => (origin as RecipeProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
