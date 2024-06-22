import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'providers/user.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MainApp(
        router: AppRouter(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key, required this.router});

  final AppRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userProvider, (prev, next) {
      router.config.refresh();
    });
    return MaterialApp.router(
      title: 'Photofeast',
      routerConfig: router.config,
      theme: ThemeData(useMaterial3: true),
    );
  }
}
