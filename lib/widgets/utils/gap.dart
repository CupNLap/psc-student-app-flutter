import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap([this.gap = 10]);
  final double gap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: gap,
      width: gap,
    );
  }
}
