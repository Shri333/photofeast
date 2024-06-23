import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({
    super.key,
    this.size = 24.0,
    this.width = 2.0,
  });

  final double size;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(strokeWidth: width),
    );
  }
}
