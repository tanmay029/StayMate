// screens/tutorial/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tutorial_controller.dart';
import '../../controllers/auth_controller.dart';

class WelcomeScreen extends StatelessWidget {
  final tutorialController = Get.put(TutorialController());
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF667eea)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Spacer(),

                // Animated logo with glow effect
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    color: Color(0xFF667eea),
                    size: 70,
                  ),
                ),

                SizedBox(height: 40),

                // Animated welcome text
                Text(
                  'Welcome to StayMate!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16),

                Text(
                  'Your perfect stay is just a few taps away',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                // Enhanced user greeting
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                //   decoration: BoxDecoration(
                //     color: Colors.white.withOpacity(0.2),
                //     borderRadius: BorderRadius.circular(25),
                //     border: Border.all(color: Colors.white.withOpacity(0.3)),
                //   ),
                //   child: Obx(() => Text(
                //     'Hello, ${authController.userDisplayName}! 👋',
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.white,
                //     ),
                //     textAlign: TextAlign.center,
                //   )),
                // ),
                Spacer(),

                // Enhanced tutorial options
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Ready to get started?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Let us show you around!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Enhanced tutorial button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            tutorialController.startTutorial();
                            Get.offAllNamed('/home');
                          },
                          icon: Icon(
                            Icons.school,
                            color: Color(0xFF667eea),
                            size: 24,
                          ),
                          label: Text(
                            'Take Tutorial',
                            style: TextStyle(
                              color: Color(0xFF667eea),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Enhanced skip button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            tutorialController.completeTutorial();
                            Get.offAllNamed('/home');
                          },
                          icon: Icon(
                            Icons.explore,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: Text(
                            'Skip & Explore',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.8),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
