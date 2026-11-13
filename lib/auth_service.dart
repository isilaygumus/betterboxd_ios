import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();

  static final ValueNotifier<Map<String, dynamic>?> currentUser = ValueNotifier(null);

  static String get userName => currentUser.value?['userName'] ?? ''; 

  static void login(Map<String, dynamic> user) => currentUser.value = user;

  static void logout() => currentUser.value = null;
}
