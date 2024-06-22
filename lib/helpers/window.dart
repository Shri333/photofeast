import 'package:flutter/material.dart';

enum Window {
  compact,
  medium,
  expanded;

  static Window fromContext(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return switch (size.width) {
      < 600 => Window.compact,
      >= 600 && < 840 => Window.medium,
      >= 840 => Window.expanded,
      _ => Window.compact
    };
  }
}
