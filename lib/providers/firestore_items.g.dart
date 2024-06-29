// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_items.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firestoreItemsServiceHash() =>
    r'ec76f0504d9fa5f73aa5f30c97cfb1c46afccee1';

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

/// See also [firestoreItemsService].
@ProviderFor(firestoreItemsService)
const firestoreItemsServiceProvider = FirestoreItemsServiceFamily();

/// See also [firestoreItemsService].
class FirestoreItemsServiceFamily extends Family<FirestoreItemsService> {
  /// See also [firestoreItemsService].
  const FirestoreItemsServiceFamily();

  /// See also [firestoreItemsService].
  FirestoreItemsServiceProvider call(
    String key,
  ) {
    return FirestoreItemsServiceProvider(
      key,
    );
  }

  @override
  FirestoreItemsServiceProvider getProviderOverride(
    covariant FirestoreItemsServiceProvider provider,
  ) {
    return call(
      provider.key,
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
  String? get name => r'firestoreItemsServiceProvider';
}

/// See also [firestoreItemsService].
class FirestoreItemsServiceProvider
    extends AutoDisposeProvider<FirestoreItemsService> {
  /// See also [firestoreItemsService].
  FirestoreItemsServiceProvider(
    String key,
  ) : this._internal(
          (ref) => firestoreItemsService(
            ref as FirestoreItemsServiceRef,
            key,
          ),
          from: firestoreItemsServiceProvider,
          name: r'firestoreItemsServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$firestoreItemsServiceHash,
          dependencies: FirestoreItemsServiceFamily._dependencies,
          allTransitiveDependencies:
              FirestoreItemsServiceFamily._allTransitiveDependencies,
          key: key,
        );

  FirestoreItemsServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  Override overrideWith(
    FirestoreItemsService Function(FirestoreItemsServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FirestoreItemsServiceProvider._internal(
        (ref) => create(ref as FirestoreItemsServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<FirestoreItemsService> createElement() {
    return _FirestoreItemsServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FirestoreItemsServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FirestoreItemsServiceRef
    on AutoDisposeProviderRef<FirestoreItemsService> {
  /// The parameter `key` of this provider.
  String get key;
}

class _FirestoreItemsServiceProviderElement
    extends AutoDisposeProviderElement<FirestoreItemsService>
    with FirestoreItemsServiceRef {
  _FirestoreItemsServiceProviderElement(super.provider);

  @override
  String get key => (origin as FirestoreItemsServiceProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
