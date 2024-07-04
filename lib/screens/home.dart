import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../helpers/snackbar.dart';
import '../helpers/window.dart';
import '../providers/user.dart';

enum HomeRoute {
  ingredients(name: 'Ingredients', iconData: Icons.kitchen),
  recipes(name: 'Recipes', iconData: Icons.fastfood),
  profile(name: 'Profile', iconData: Icons.person);

  const HomeRoute({
    required this.name,
    required this.iconData,
  });

  final String name;
  final IconData iconData;

  String get path => '/${name.toLowerCase()}';

  static HomeRoute? route(String path) {
    final recipesRegExp = RegExp(r'^/recipes/[a-zA-Z0-9]{20}$');
    if (recipesRegExp.hasMatch(path)) {
      return HomeRoute.recipes;
    }
    return switch (path) {
      '/ingredients' => HomeRoute.ingredients,
      '/recipes' => HomeRoute.recipes,
      '/profile' => HomeRoute.profile,
      _ => null,
    };
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.routerState,
    required this.child,
  });

  final GoRouterState routerState;
  final Widget child;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    if (user case AsyncData(:final value)
        when value != null && !value.emailVerified) {
      showSnackBar(context, 'Please verify your email');
    }
    _handlePath();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handlePath();
  }

  void _handlePath() {
    final path = widget.routerState.uri.path;
    final route = HomeRoute.route(path);
    if (route != null) {
      _index = route.index;
    }
  }

  void _onIndexChange(int index) {
    context.go(HomeRoute.values[index].path);
  }

  AppBar _buildAppBar() {
    final themeData = Theme.of(context);
    return AppBar(
      title: Text(
        'Photofeast',
        style: themeData.textTheme.headlineSmall?.copyWith(
          color: themeData.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: themeData.primaryColor,
    );
  }

  Widget _buildWithBottomBar() {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (final HomeRoute(:name, :iconData) in HomeRoute.values)
            BottomNavigationBarItem(
              icon: Icon(iconData),
              label: name,
            )
        ],
        selectedItemColor: themeData.primaryColor,
        currentIndex: _index,
        onTap: _onIndexChange,
      ),
    );
  }

  Widget _buildWithNavRail() {
    final themeData = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Row(
        children: [
          NavigationRail(
            extended: Window.fromContext(context) == Window.expanded,
            destinations: [
              for (final HomeRoute(:name, :iconData) in HomeRoute.values)
                NavigationRailDestination(
                  icon: Icon(iconData),
                  label: Text(name),
                )
            ],
            selectedIconTheme: themeData.iconTheme.copyWith(
              color: themeData.primaryColor,
            ),
            selectedLabelTextStyle: themeData.textTheme.bodySmall?.copyWith(
              color: themeData.primaryColor,
            ),
            selectedIndex: _index,
            onDestinationSelected: _onIndexChange,
          ),
          const VerticalDivider(
            thickness: 1.0,
            width: 1.0,
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Window.fromContext(context) == Window.compact
        ? _buildWithBottomBar()
        : _buildWithNavRail();
  }
}
