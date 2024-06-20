import 'package:flutter/material.dart';
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
  homeRedirect(
    BuildContext context,
    GoRouterState state,
  ) =>
      switch (user) {
        AsyncData(:final value) when value == null => '/login',
        _ => null,
      };
  authRedirect(
    BuildContext context,
    GoRouterState state,
  ) =>
      switch (user) {
        AsyncData(:final value) when value != null => '/',
        _ => null,
      };
  final router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      redirect: homeRedirect,
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
      redirect: authRedirect,
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
      redirect: authRedirect,
    )
  ], initialLocation: '/login');
  return router;
}
