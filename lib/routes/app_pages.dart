// routes/app_pages.dart
import 'package:get/get.dart';
import 'package:staymate/screens/booking/booking_confirmation_screen.dart';
import 'package:staymate/screens/booking/booking_detail_screen.dart';
import 'package:staymate/screens/booking/booking_success_screen.dart';
import 'package:staymate/screens/booking/my_bookings_screen.dart';
import 'package:staymate/screens/booking/payment_screen.dart';
import 'package:staymate/screens/profile/edit_profile_screen.dart';
import 'package:staymate/screens/profile/profile_screen.dart';
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
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: Routes.PROPERTY_DETAIL,
      page: () => PropertyDetailScreen(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingsScreen(),
    ),
    GetPage(
  name: '/forgot-password',
  page: () => ForgotPasswordScreen(),
),
GetPage(
  name: '/booking-confirmation',
  page: () => BookingConfirmationScreen(),
),
GetPage(
  name: '/payment',
  page: () => PaymentScreen(),
),
GetPage(
  name: '/booking-success',
  page: () => BookingSuccessScreen(),
),
GetPage(
  name: '/bookings',
  page: () => MyBookingsScreen(),
),
GetPage(
  name: '/profile',
  page: () => ProfileScreen(),
),
GetPage(
  name: '/booking-detail',
  page: () => BookingDetailScreen(),
),
GetPage(
  name: '/edit-profile',
  page: () => EditProfileScreen(),
),
  ];
}
