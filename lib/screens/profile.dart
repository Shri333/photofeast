import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user.dart';
import '../widgets/spinner.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Widget _buildMainView(User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Email: ${user.email}'),
                Text('Verified: ${user.emailVerified}'),
              ],
            ),
          ),
          if (!user.emailVerified)
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () {},
                child: const Text('Verify Email'),
              ),
            ),
          if (!user.emailVerified) const SizedBox(height: 4.0),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: FirebaseAuth.instance.signOut,
              child: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return switch (user) {
      AsyncLoading() => const Center(child: Spinner()),
      AsyncData(:final value) when value != null => _buildMainView(value),
      _ => const Center(
          child: Text('There was an error fetching user data'),
        ),
    };
  }
}
