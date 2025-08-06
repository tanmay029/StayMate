// widgets/tutorial_overlay.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tutorial_controller.dart';
import 'spotlight_painter.dart';

class TutorialOverlay extends StatefulWidget {
  final Widget child;

  const TutorialOverlay({Key? key, required this.child}) : super(key: key);

  @override
  _TutorialOverlayState createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tutorialController = Get.find<TutorialController>();

    return Obx(() {
      if (!tutorialController.isTutorialActive.value) {
        return widget.child;
      }

      return Stack(
        children: [
          widget.child,
          _buildSpotlightOverlay(context, tutorialController),
        ],
      );
    });
  }

  Widget _buildSpotlightOverlay(BuildContext context, TutorialController controller) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Spotlight overlay that doesn't block gestures on highlighted widget
              _buildSpotlightBackground(controller),
              
              // Tutorial content positioned dynamically
              _buildTutorialContent(context, controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpotlightBackground(TutorialController controller) {
    return Obx(() {
      final highlightKey = controller.highlightKey.value;
      Rect? spotlightRect;

      if (highlightKey?.currentContext != null) {
        final RenderBox renderBox = 
            highlightKey!.currentContext!.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final position = renderBox.localToGlobal(Offset.zero);

        spotlightRect = Rect.fromLTWH(
          position.dx,
          position.dy,
          size.width,
          size.height,
        );
      }

      return IgnorePointer(
        ignoring: false,
        child: CustomPaint(
          painter: SpotlightPainter(
            spotlightRect: spotlightRect,
            animationValue: _pulseAnimation.value,
          ),
          size: Size.infinite,
        ),
      );
    });
  }

  Widget _buildTutorialContent(BuildContext context, TutorialController controller) {
    return Obx(() {
      final highlightKey = controller.highlightKey.value;
      final screenSize = MediaQuery.of(context).size;
      
      // Calculate optimal position for tutorial card
      EdgeInsets cardMargin = EdgeInsets.all(20);
      MainAxisAlignment cardAlignment = MainAxisAlignment.center;
      
      if (highlightKey?.currentContext != null) {
        final RenderBox renderBox = 
            highlightKey!.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final widgetRect = Rect.fromLTWH(
          position.dx,
          position.dy,
          renderBox.size.width,
          renderBox.size.height,
        );

        // Smart positioning logic
        final spaceAbove = widgetRect.top;
        final spaceBelow = screenSize.height - widgetRect.bottom;
        final cardHeight = 400.0; // Estimated card height

        if (spaceBelow > cardHeight + 100) {
          // Position below the widget
          cardAlignment = MainAxisAlignment.end;
          cardMargin = EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: spaceBelow > 200 ? 100 : 50,
          );
        } else if (spaceAbove > cardHeight + 100) {
          // Position above the widget
          cardAlignment = MainAxisAlignment.start;
          cardMargin = EdgeInsets.only(
            left: 20,
            right: 20,
            top: spaceAbove > 200 ? 100 : 50,
          );
        } else {
          // Position in center, offset horizontally if needed
          cardAlignment = MainAxisAlignment.center;
          final widgetCenter = widgetRect.center;
          
          if (widgetCenter.dx < screenSize.width * 0.3) {
            // Widget on left, position card on right
            cardMargin = EdgeInsets.only(left: 180, right: 20, top: 20, bottom: 20);
          } else if (widgetCenter.dx > screenSize.width * 0.7) {
            // Widget on right, position card on left
            cardMargin = EdgeInsets.only(left: 20, right: 180, top: 20, bottom: 20);
          }
        }
      }

      return SafeArea(
        child: Column(
          mainAxisAlignment: cardAlignment,
          children: [
            // Progress indicator at top
            if (cardAlignment != MainAxisAlignment.start)
              _buildEnhancedProgressIndicator(controller),
            
            // Spacer for flexible positioning
            if (cardAlignment == MainAxisAlignment.center) Spacer(),
            
            // Tutorial card
            Container(
              margin: cardMargin,
              child: _buildTutorialCard(context, controller),
            ),
            
            // Spacer for flexible positioning
            if (cardAlignment == MainAxisAlignment.center) Spacer(),
            
            // Navigation buttons at bottom
            if (cardAlignment != MainAxisAlignment.end)
              _buildEnhancedNavigationButtons(controller),
          ],
        ),
      );
    });
  }

  Widget _buildEnhancedProgressIndicator(TutorialController controller) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.school,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              'Tutorial',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 20),
            Text(
              '${controller.currentTutorialStep.value + 1} of ${controller.tutorialSteps.length}',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(width: 16),
            Container(
              width: 100,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (controller.currentTutorialStep.value + 1) / controller.tutorialSteps.length,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.cyan, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialCard(BuildContext context, TutorialController controller) {
    final step = controller.tutorialSteps[controller.currentTutorialStep.value];
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        constraints: BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: step.gradientColors,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: step.gradientColors.first.withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated icon with gradient background
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: step.gradientColors,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: step.gradientColors.first.withOpacity(0.4),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    step.icon,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Title with gradient text
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: step.gradientColors,
                ).createShader(bounds),
                child: Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              
              // Description
              Text(
                step.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28),
              
              // Enhanced action button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: step.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: step.gradientColors.first.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    step.action,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedNavigationButtons(TutorialController controller) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            // Back button
            if (controller.currentTutorialStep.value > 0)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: TextButton.icon(
                  onPressed: controller.previousStep,
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 18),
                  label: Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            
            Spacer(),
            
            // Skip button
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: TextButton.icon(
                onPressed: controller.skipTutorial,
                icon: Icon(Icons.skip_next, color: Colors.white70, size: 18),
                label: Text(
                  'Skip Tutorial',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
