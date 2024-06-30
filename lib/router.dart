import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/user.dart';
import 'screens/home.dart';
import 'screens/ingredients.dart';
import 'screens/login.dart';
import 'screens/profile.dart';
import 'screens/recipe.dart';
import 'screens/recipes.dart';
import 'screens/signup.dart';
import 'widgets/page_not_found.dart';

class AppRouter {
  late final GoRouter config;

  static final _instance = AppRouter._();

  factory AppRouter() {
    return _instance;
  }

  AppRouter._() {
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
                routes: [
                  GoRoute(
                    path: ':recipeId',
                    pageBuilder: (context, state) => NoTransitionPage(
                      child: RecipeScreen(
                        recipeId: state.pathParameters['recipeId'],
                      ),
                    ),
                  ),
                ],
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
      errorPageBuilder: (context, state) => const NoTransitionPage(
        child: PageNotFoundWidget(),
      ),
    );
  }

  User? _getUser(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    final user = container.read(userProvider);
    if (user case AsyncData(:final value)) {
      return value;
    }
    return null;
  }

  String? _redirectToAuth(BuildContext context, GoRouterState state) {
    final user = _getUser(context);
    return user == null ? '/login' : null;
  }

  String? _redirectToHome(BuildContext context, GoRouterState state) {
    final user = _getUser(context);
    return user != null ? '/' : null;
  }
}
