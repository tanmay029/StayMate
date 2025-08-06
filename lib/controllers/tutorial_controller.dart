// controllers/tutorial_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TutorialController extends GetxController {
  final _box = GetStorage();
  final showTutorial = false.obs;
  final currentTutorialStep = 0.obs;
  final isTutorialActive = false.obs;
  final highlightKey = Rxn<GlobalKey>();

  @override
  void onInit() {
    super.onInit();
    _checkIfFirstLaunch();
  }

  void _checkIfFirstLaunch() {
    final hasSeenTutorial = _box.read('has_seen_tutorial') ?? false;
    if (!hasSeenTutorial) {
      showTutorial.value = true;
    }
  }

  void startTutorial() {
    isTutorialActive.value = true;
    currentTutorialStep.value = 0;
    _updateHighlight();
  }

  void nextStep() {
    if (currentTutorialStep.value < tutorialSteps.length - 1) {
      currentTutorialStep.value++;
      _updateHighlight();
    } else {
      completeTutorial();
    }
  }

  void previousStep() {
    if (currentTutorialStep.value > 0) {
      currentTutorialStep.value--;
      _updateHighlight();
    }
  }

  void _updateHighlight() {
    final step = tutorialSteps[currentTutorialStep.value];
    if (step.targetKey != null) {
      highlightKey.value = step.targetKey;
    } else {
      highlightKey.value = null;
    }
  }

  void skipTutorial() {
    completeTutorial();
  }

  void completeTutorial() {
    isTutorialActive.value = false;
    showTutorial.value = false;
    currentTutorialStep.value = 0;
    highlightKey.value = null;
    _box.write('has_seen_tutorial', true);
  }

  void resetTutorial() {
    _box.remove('has_seen_tutorial');
    showTutorial.value = true;
    startTutorial();
  }

  // Tutorial steps with target keys for highlighting
  final List<TutorialStep> tutorialSteps = [
    TutorialStep(
      title: "Welcome to StayMate! 🏠",
      description: "Discover amazing properties and book your perfect stay with ease. Let's take a quick tour!",
      icon: Icons.waving_hand,
      gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
      action: "Let's Start!",
    ),
    TutorialStep(
      title: "Search Properties 🔍",
      description: "Use the search bar to find properties by location, name, or any keyword. Try searching for your dream destination!",
      icon: Icons.search,
      gradientColors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      action: "Got it!",
      targetKey: GlobalKey(),
      highlightId: "search_bar",
    ),
    TutorialStep(
      title: "Filter by Category 🏷️",
      description: "Filter properties by type: Apartments, Villas, Hotels, Cabins, or Houses. Find exactly what you're looking for!",
      icon: Icons.filter_list,
      gradientColors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
      action: "Understood!",
      targetKey: GlobalKey(),
      highlightId: "filter_chips",
    ),
    TutorialStep(
      title: "Save to Favorites ❤️",
      description: "Tap the heart icon on any property card to save it to your favorites for quick access later.",
      icon: Icons.favorite,
      gradientColors: [Color(0xFFfa709a), Color(0xFFfee140)],
      action: "Love it!",
      targetKey: GlobalKey(),
      highlightId: "heart_icon",
    ),
    TutorialStep(
      title: "View Property Details 📋",
      description: "Tap on any property card to see detailed information, stunning photos, amenities, and genuine reviews.",
      icon: Icons.info_outline,
      gradientColors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
      action: "Clear!",
      targetKey: GlobalKey(),
      // highlightId: "property_card",
    ),
    TutorialStep(
      title: "Book Your Stay 📅",
      description: "Select your check-in and check-out dates, choose number of guests, and tap 'Book Now' to secure your reservation.",
      icon: Icons.calendar_today,
      gradientColors: [Color(0xFFffecd2), Color(0xFFfcb69f)],
      action: "Perfect!",
      targetKey: GlobalKey(),
      highlightId: "book_button",
    ),
    TutorialStep(
      title: "Manage Your Bookings 📝",
      description: "View all your bookings in the Bookings tab. Cancel within 24 hours or write reviews for completed stays.",
      icon: Icons.bookmark,
      gradientColors: [Color(0xFFd299c2), Color(0xFFfef9d7)],
      action: "Awesome!",
      targetKey: GlobalKey(),
      highlightId: "bookings_tab",
    ),
    TutorialStep(
      title: "Access Your Favorites 💖",
      description: "Tap the heart icon in the top-left corner to view all your favorite properties in one convenient place.",
      icon: Icons.favorite_border,
      gradientColors: [Color(0xFFfc466b), Color(0xFF3f5efb)],
      action: "Great!",
      targetKey: GlobalKey(),
      highlightId: "favorites_button",
    ),
    TutorialStep(
      title: "You're All Set! 🎉",
      description: "Congratulations! You're now ready to explore amazing properties and book your perfect stay. Happy travels with StayMate!",
      icon: Icons.celebration,
      gradientColors: [Color(0xFFffeaa7), Color(0xFFfab1a0)],
      action: "Start Exploring!",
    ),
  ];
}

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final String action;
  final GlobalKey? targetKey;
  final String? highlightId;

  TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.action,
    this.targetKey,
    this.highlightId,
  });
}
