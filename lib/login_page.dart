import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Digunakan untuk Authentication
// Import halaman tujuan setelah login sukses
import 'home_screen.dart'; 
// import 'package:http/http.dart' as http; // Tidak digunakan lagi untuk login
// import 'dart:convert'; // Tidak digunakan lagi untuk login

// -----------------------------------------------------------
// WIDGET PEMBANTU (Helper Widgets)
// -----------------------------------------------------------

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

// Tombol Register diubah agar bisa memanggil fungsi register dari luar
class RowButton extends StatelessWidget {
  final VoidCallback onRegisterPressed;
  const RowButton({super.key, required this.onRegisterPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Login (hanya sebagai placeholder karena form utama sudah ada)
        ElevatedButton(onPressed: () {}, child: const Text("Login")), 
        const SizedBox(width: 16),
        // Tombol Register memanggil fungsi dari parent widget
        ElevatedButton(
          onPressed: onRegisterPressed, // Panggil fungsi register
          child: const Text("Register")
        ),
      ],
    );
  }
}

// -----------------------------------------------------------
// WIDGET UTAMA (LOGIN PAGE)
// -----------------------------------------------------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ------------------------------------------------
  // LOGIKA UTAMA FIREBASE AUTH
  // ------------------------------------------------

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password harus diisi.')),
      );
      return;
    }

    try {
      // Panggil fungsi Login dari Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Login SUKSES!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Berhasil!')),
      );

      // Navigasi ke Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Error yang spesifik dari Firebase
      String errorMessage = "Login Gagal. Terjadi kesalahan.";

      if (e.code == 'user-not-found') {
        errorMessage = 'Pengguna tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid.';
      }
      
      print("Firebase Error: ${e.code}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Handle error umum
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan koneksi atau lainnya.')),
      );
    }
  }

  Future<void> _register() async {
    // Fungsi Register (Bisa dipanggil dari RowButton)
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password harus diisi untuk Registrasi.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Registrasi SUKSES!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi Berhasil! Silakan Login.')),
      );
      
      // Langsung lakukan login
      _login();

    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registrasi Gagal.';
      if (e.code == 'weak-password') {
        errorMessage = 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email sudah terdaftar.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold( 
      child: SingleChildScrollView( 
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WelcomePart(), 
            const SizedBox(height: 16),
            const Text(
              "Senang bertemu denganmu lagi! Silakan masukkan akun Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // INPUT EMAIL/USERNAME
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // INPUT PASSWORD
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // TOMBOL LOGIN UTAMA
            ElevatedButton(
              onPressed: _login, // Memanggil fungsi login Firebase
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 18),
              ),
            ),
            
            // TOMBOL REGISTER (Memanggil fungsi _register)
            const SizedBox(height: 16),
            RowButton(onRegisterPressed: _register), 
          ],
        ),
      ),
    );
  }
}