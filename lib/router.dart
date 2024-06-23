import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/user.dart';
import 'screens/home.dart';
import 'screens/ingredients.dart';
import 'screens/login.dart';
import 'screens/profile.dart';
import 'screens/recipes.dart';
import 'screens/signup.dart';

class AppRouter {
  static final _instance = AppRouter._privateConstructor();

  late final GoRouter config;

  AppRouter._privateConstructor() {
    config = GoRouter(
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
          redirect: _redirectToHome,
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
          redirect: _redirectToHome,
        ),
        GoRoute(
          path: '/',
          redirect: (context, state) => '/ingredients',
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, child) => HomeScreen(
            routerState: state,
            child: child,
          ),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                path: HomeRoute.ingredients.path,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: IngredientsScreen(),
                ),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: HomeRoute.recipes.path,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: RecipesScreen(),
                ),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: HomeRoute.profile.path,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ]),
          ],
          redirect: _redirectToAuth,
        ),
      ],
      initialLocation: '/login',
    );
  }

  factory AppRouter() {
    return _instance;
  }

  AsyncValue<User?> _user(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    return container.read(userProvider);
  }

  String? _redirectToAuth(BuildContext context, GoRouterState state) {
    final user = _user(context);
    if (user case AsyncData(:final value) when value == null) {
      return '/login';
    }
    return null;
  }

  String? _redirectToHome(BuildContext context, GoRouterState state) {
    final user = _user(context);
    if (user case AsyncData(:final value) when value != null) {
      return '/';
    }
    return null;
  }
}
