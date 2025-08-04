import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final _box = GetStorage();
  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    final userData = _box.read('user');
    if (userData != null) {
      currentUser.value = User.fromJson(userData);
      isLoggedIn.value = true;
    }
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    
    if (email.isNotEmpty && password.length >= 6) {
      final user = User(
        id: '1',
        fullName: 'John Doe',
        email: email,
        phone: '+1234567890',
      );
      
      currentUser.value = user;
      isLoggedIn.value = true;
      _box.write('user', user.toJson());
      return true;
    }
    return false;
  }

  Future<bool> register(String fullName, String email, String phone, String password) async {
    await Future.delayed(Duration(seconds: 1));
    
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      phone: phone,
    );
    
    currentUser.value = user;
    isLoggedIn.value = true;
    _box.write('user', user.toJson());
    return true;
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    _box.remove('user');
    Get.offAllNamed('/login');
  }
}
