import 'package:flutter/material.dart';
import 'view/login_view.dart';
import 'view/register_view.dart';
import 'view/home_view.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const study = '/study';
  static const library = '/library';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginView(),
    register: (context) => const RegisterView(),
    home: (context) => const HomeView(),
    study: (context) => const Placeholder(),
    library: (context) => const Placeholder(),
  };
}
