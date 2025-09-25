import 'package:flutter/material.dart';
import 'package:meraapss/home_page.dart';
import 'package:meraapss/splash_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: { 
      '/': (context) => SplashPage(),
      '/home': (context) => HomePage(),
      },
    );
  }
}