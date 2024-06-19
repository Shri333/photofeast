import 'package:go_router/go_router.dart';
import 'package:photofeast/screens/home.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
]);
