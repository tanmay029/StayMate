import 'package:get/get.dart';
import 'package:staymate/screens/booking/booking_confirmation_screen.dart';
import 'package:staymate/screens/booking/booking_detail_screen.dart';
import 'package:staymate/screens/booking/booking_success_screen.dart';
import 'package:staymate/screens/booking/my_bookings_screen.dart';
import 'package:staymate/screens/booking/payment_screen.dart';
import 'package:staymate/screens/booking/review_screen.dart';
import 'package:staymate/screens/profile/edit_profile_screen.dart';
import 'package:staymate/screens/profile/profile_screen.dart';
import 'package:staymate/screens/property/property_reviews_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/property/property_detail_screen.dart';
import '../screens/settings/settings_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(name: Routes.PROPERTY_DETAIL, page: () => PropertyDetailScreen()),
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingsScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/forgot-password',
      page: () => ForgotPasswordScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/booking-confirmation',
      page: () => BookingConfirmationScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/payment',
      page: () => PaymentScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/booking-success',
      page: () => BookingSuccessScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/bookings',
      page: () => MyBookingsScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/booking-detail',
      page: () => BookingDetailScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/edit-profile',
      page: () => EditProfileScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
  name: '/review',
  page: () => ReviewScreen(),
  transition: Transition.noTransition,
),
GetPage(
  name: '/property-reviews',
  page: () => PropertyReviewsScreen(),
  transition: Transition.noTransition,
),
  ];
}
