// widgets/highlighted_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tutorial_controller.dart';

class HighlightedWidget extends StatelessWidget {
  final Widget child;
  final String highlightId;
  final GlobalKey widgetKey;

  const HighlightedWidget({
    Key? key,
    required this.child,
    required this.highlightId,
    required this.widgetKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tutorialController = Get.find<TutorialController>();

    return Obx(() {
      final isHighlighted = tutorialController.isTutorialActive.value &&
          tutorialController.tutorialSteps[tutorialController.currentTutorialStep.value].highlightId == highlightId;

      if (isHighlighted) {
        // Update the controller with this widget's key
        WidgetsBinding.instance.addPostFrameCallback((_) {
          tutorialController.highlightKey.value = widgetKey;
        });
      }

      return Container(
        key: widgetKey,
        // Remove any decoration that might interfere with spotlight
        child: child,
      );
    });
  }
}
