import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photofeast/providers/user.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final user = ref.watch(userProvider);
    print(user);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 480.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Photofeast',
                  style: themeData.textTheme.displayMedium?.copyWith(
                    color: themeData.primaryColor,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      size: 20.0,
                    ),
                    label: const Text('Sign in with Google'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.facebook),
                    label: const Text('Sign in with Facebook'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
