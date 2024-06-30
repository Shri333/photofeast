import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/alert.dart';
import '../providers/firestore_items.dart';
import '../providers/preferences.dart';
import '../providers/user.dart';
import '../services/firestore_items.dart';
import '../widgets/scroll.dart';
import '../widgets/spinner.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _preferenceController = TextEditingController();

  late final FirestoreItemsService _preferencesService;

  @override
  void initState() {
    super.initState();
    _preferencesService = ref.read(
      firestoreItemsServiceProvider('preferences'),
    );
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

  void _addPreference(List<String> preferences, String preference) {
    if (preference.isEmpty) {
      return;
    }
    _withFirebaseErrorHandling(() async {
      final added = await _preferencesService.addItem(
        preferences,
        preference,
      );
      if (!added && mounted) {
        showErrorAlert(context, '$preference already exists');
      }
      return added;
    });
  }

  void _removePreference(List<String> preferences, int index) {
    _withFirebaseErrorHandling(
      () => _preferencesService.removeItem(preferences, index),
    );
  }

  Future<void> _verifyEmail(User user) async {
    await user.sendEmailVerification();
    if (mounted) {
      showAlert(
        context,
        'Info',
        'Sent verification email to ${user.email}',
      );
    }
  }

  Text _getVerifiedText(User user) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme.headlineSmall;
    if (user.emailVerified) {
      return Text(
        'VERIFIED',
        style: textTheme?.copyWith(color: Colors.green[500]),
      );
    }
    return Text(
      'NOT VERIFIED',
      style: textTheme?.copyWith(color: Colors.red[500]),
    );
  }

  Widget _buildMainView(List<String> preferences) {
    final themeData = Theme.of(context);
    final user = ref.read(userProvider);
    if (user case AsyncData(:final value) when value != null) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Scroll(
          child: Column(
            children: [
              Text(
                'Profile',
                style: themeData.textTheme.displayMedium?.copyWith(
                  color: themeData.primaryColor,
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 24.0),
                  Text(
                    value.email!,
                    style: themeData.textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified),
                  const SizedBox(width: 24.0),
                  (_getVerifiedText(value)),
                ],
              ),
              const SizedBox(height: 24.0),
              TextField(
                controller: _preferenceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add a dietary preference',
                ),
                onSubmitted: (value) {
                  final preference = value.trim().toLowerCase();
                  _addPreference(preferences, preference);
                  _preferenceController.clear();
                },
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 4.0,
                runSpacing: 2.0,
                children: List<InputChip>.generate(
                  preferences.length,
                  (index) => InputChip(
                    label: Text(preferences[index]),
                    onDeleted: () {
                      _removePreference(preferences, index);
                    },
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 4.0),
              if (!value.emailVerified)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () {
                      _verifyEmail(value);
                    },
                    child: const Text('Verify Email'),
                  ),
                ),
              if (!value.emailVerified) const SizedBox(height: 4.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: FirebaseAuth.instance.signOut,
                  child: const Text('Log Out'),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const Center(child: Spinner());
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesProvider);
    return switch (preferences) {
      AsyncLoading() => const Center(child: Spinner()),
      AsyncData(:final value) when value != null => _buildMainView(value),
      _ => _buildMainView([]),
    };
  }
}
