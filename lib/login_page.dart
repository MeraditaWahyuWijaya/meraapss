import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  const CustomScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: child),
      ),
    );
  }
}

class WelcomePart extends StatelessWidget {
  const WelcomePart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Welcome!",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

class RowButton extends StatelessWidget {
  const RowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text("Login")),
        const SizedBox(width: 16),
        ElevatedButton(onPressed: () {}, child: const Text("Register")),
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WelcomePart(),
          SizedBox(height: 40),
          Text( "Senang bertemu denganmu lagi!",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          RowButton(),
        ],
      ),
    );
  }
}
