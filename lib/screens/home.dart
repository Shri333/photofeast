import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../helpers/window.dart';

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
    return switch (path) {
      '/ingredients' => HomeRoute.ingredients,
      '/recipes' => HomeRoute.recipes,
      '/profile' => HomeRoute.profile,
      _ => null,
    };
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.routerState,
    required this.child,
  });

  final GoRouterState routerState;
  final Widget child;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  Window _window = Window.compact;
  ThemeData _themeData = ThemeData();

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    return AppBar(
      title: Text(
        'Photofeast',
        style: _themeData.textTheme.headlineSmall?.copyWith(
          color: _themeData.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: _themeData.primaryColor,
    );
  }

  Widget _buildWithBottomBar() {
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
        selectedItemColor: _themeData.primaryColor,
        currentIndex: _index,
        onTap: _onIndexChange,
      ),
    );
  }

  Widget _buildWithNavRail() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: [
          NavigationRail(
            extended: _window == Window.expanded,
            destinations: [
              for (final HomeRoute(:name, :iconData) in HomeRoute.values)
                NavigationRailDestination(
                  icon: Icon(iconData),
                  label: Text(name),
                )
            ],
            selectedIconTheme: _themeData.iconTheme.copyWith(
              color: _themeData.primaryColor,
            ),
            selectedLabelTextStyle: _themeData.textTheme.bodySmall?.copyWith(
              color: _themeData.primaryColor,
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
    _window = Window.fromContext(context);
    _themeData = Theme.of(context);
    return _window == Window.compact
        ? _buildWithBottomBar()
        : _buildWithNavRail();
  }
}
