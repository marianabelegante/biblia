import 'package:get/get.dart';
import 'view/login_view.dart';
import 'view/register_view.dart';
import 'view/bible_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/login', page: () => LoginView()),
    GetPage(name: '/register', page: () => RegisterView()),
    GetPage(name: '/bible', page: () => BibleView()),
  ];
}
