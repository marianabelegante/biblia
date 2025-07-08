import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'app_routes.dart'; // Renomeado de routes.dart para evitar conflito
import 'firebase_options.dart'; // Arquivo gerado pelo FlutterFire CLI

void main() async {
  // Garante que os widgets Flutter estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bíblia Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      // A rota inicial é verificada no AuthController
      // Se o usuário estiver logado, vai para /bible, senão para /login
      initialRoute: '/login',
      getPages: AppRoutes.routes,
    );
  }
}
