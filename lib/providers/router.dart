import 'package:go_router/go_router.dart';
import 'package:photofeast/providers/user.dart';
import 'package:photofeast/screens/home.dart';
import 'package:photofeast/screens/login.dart';
import 'package:photofeast/screens/signup.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final user = ref.watch(userProvider);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      )
    ],
    redirect: (context, state) => switch (user) {
      AsyncData(:final value) =>
        value == null && state.uri.path != '/signup' ? '/login' : null,
      _ => null
    },
  );
  return router;
}
