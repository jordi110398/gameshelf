import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/features/auth/widgets/auth_text_field.dart';
import 'package:gameshelf/core/services/profile_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nicknameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
  try {
    await authService.signUp(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    await ProfileService().createProfile(
      nickname: nicknameController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Compte creat correctament!"),
      ),
    );

    context.go("/");
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
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
                  controller: nicknameController,
                  label: "Nickname",
                  icon: Icons.person,
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _register,
                    child: const Text("Create account"),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => context.go("/"),
                  child: const Text("Already have an account? Log in"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
