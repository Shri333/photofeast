import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/user.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/signup.dart';

class AppRouter {
  static final _instance = AppRouter._privateConstructor();

  late final GoRouter config;

  AppRouter._privateConstructor() {
    config = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          redirect: _homeRedirect,
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
          redirect: _authRedirect,
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
          redirect: _authRedirect,
        )
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

  String? _homeRedirect(BuildContext context, GoRouterState state) {
    final user = _user(context);
    if (user case AsyncData(:final value) when value == null) {
      return '/login';
    }
    return null;
  }

  String? _authRedirect(BuildContext context, GoRouterState state) {
    final user = _user(context);
    if (user case AsyncData(:final value) when value != null) {
      return '/';
    }
    return null;
  }
}
