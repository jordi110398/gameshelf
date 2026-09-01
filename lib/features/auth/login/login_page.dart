import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import 'package:gameshelf/core/services/profile_service.dart';
import 'package:gameshelf/core/utils/error_messages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  final profileService = ProfileService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;
  bool _resettingPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // INICIAR SESSIÓ
  // ─────────────────────────────────────────────

  Future<void> _login() async {
    setState(() => _loading = true);

    try {
      String input = emailController.text.trim();

      if (!input.contains("@")) {
        input = await profileService.getEmailFromNickname(input) ?? "";

        if (input.isEmpty) {
          throw Exception("No s'ha trobat cap usuari amb aquest nickname.");
        }
      }

      await authService.signIn(email: input, password: passwordController.text);

      if (!mounted) return;

      context.go("/home");
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyError(e))));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // ─────────────────────────────────────────────
  // OBLIDAR CONTRASENYA
  // ─────────────────────────────────────────────

  Future<void> _forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Introdueix el teu email per recuperar la contrasenya.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _resettingPassword = true;
    });

    try {
      await authService.resetPassword(email);

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Revisa el teu correu'),
            content: const Text(
              'T\'hem enviat un enllaç per restablir la contrasenya. '
              'Revisa la safata d\'entrada i també la carpeta de correu brossa.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('D\'acord'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No s\'ha pogut enviar el correu: ${friendlyError(e)}'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _resettingPassword = false;
        });
      }
    }
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
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

                  // EMAIL / NICKNAME
                  AuthTextField(
                    controller: emailController,
                    label: "Email o usuari",
                    icon: Icons.email,
                  ),

                  const SizedBox(height: 20),

                  // CONTRASENYA
                  AuthTextField(
                    controller: passwordController,
                    label: "Contrasenya",
                    icon: Icons.lock,
                    obscureText: true,
                  ),

                  const SizedBox(height: 8),

                  // OBLIDAR CONTRASENYA
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _loading || _resettingPassword
                          ? null
                          : _forgotPassword,
                      child: _resettingPassword
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("He oblidat la contrasenya"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // INICIAR SESSIÓ
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _loading || _resettingPassword ? null : _login,
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

                  // CREAR COMPTE
                  TextButton(
                    onPressed: _loading || _resettingPassword
                        ? null
                        : () => context.go("/register"),
                    child: const Text("Crear compte"),
                  ),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: () => context.push('/about'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                    child: const Text(
                      'Sobre GameShelf',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
