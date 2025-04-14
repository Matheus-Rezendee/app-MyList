import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/item.dart';
import 'models/category.dart';
import 'providers/list_provider.dart';
import 'screens/category_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Registra os adaptadores Hive para Item e Category
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(CategoryAdapter());

  // Abertura das caixas
  await Hive.openBox<Item>('items');
  await Hive.openBox<Category>('categories');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListProvider()..loadData(), // Carrega os dados ao iniciar
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista Inteligente',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/onboarding': (_) => const OnboardingScreen(),
          '/auth': (_) => const AuthScreen(isLogin: true),
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}
