import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Rx<User?> user = Rx<User?>(null);
  var isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Binda o stream de autenticação à variável reativa 'user'
    user.bindStream(_authService.authStateChanges);
    // Redireciona o usuário com base no estado de autenticação
    ever(user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      Get.offAllNamed('/bible');
    }
  }

  void login() async {
    isLoading.value = true;
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (userCredential != null) {
        Get.offAllNamed('/bible');
      } else {
        Get.snackbar(
          'Erro de Login',
          'E-mail ou senha inválidos.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void register() async {
    isLoading.value = true;
    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (userCredential != null) {
        Get.offAllNamed('/bible');
      } else {
        Get.snackbar(
          'Erro de Cadastro',
          'Não foi possível criar a conta. Tente novamente.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _authService.signOut();
    Get.offAllNamed('/login');
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}