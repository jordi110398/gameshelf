import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);

    try {
      await authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      print(authService.currentSession);
      print(authService.currentUser);
      print(authService.currentSession);

      if (!mounted) return;

      context.go("/home");

      // No fem context.go("/home")
      // El GoRouter detectarà automàticament
      // que hi ha sessió i redirigirà.
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sports_esports, size: 80),

                const SizedBox(height: 24),

                const Text(
                  "GameShelf",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                AuthTextField(
                  controller: emailController,
                  label: "Correu electrònic",
                  icon: Icons.email,
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: passwordController,
                  label: "Contrasenya",
                  icon: Icons.lock,
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Inicia sessió"),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => context.go("/register"),
                  child: const Text("Crear compte"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
