// widgets/tutorial_target.dart
import 'package:flutter/material.dart';

class TutorialTarget extends StatelessWidget {
  final Widget child;
  final String targetId;
  final GlobalKey targetKey;

  const TutorialTarget({
    Key? key,
    required this.child,
    required this.targetId,
    required this.targetKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: targetKey,
      child: child,
    );
  }
}
