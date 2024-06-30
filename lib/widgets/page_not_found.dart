import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageNotFoundWidget extends StatelessWidget {
  const PageNotFoundWidget({
    super.key,
    this.message = 'Page not found',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: themeData.textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () {
              context.go('/');
            },
            child: const Text('Go Home'),
          )
        ],
      ),
    );
  }
}
