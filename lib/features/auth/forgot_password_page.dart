import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/features/auth/widgets/auth_text_field.dart';
import 'package:gameshelf/core/utils/error_messages.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {
  final authService = AuthService();

  final emailController = TextEditingController();

  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introdueix el teu email.'),
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await authService.resetPassword(email);

      if (!mounted) return;

      setState(() {
        _sent = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No s\'ha pogut enviar el correu: ${friendlyError(e)}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: _sent
                ? Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.mark_email_read_outlined,
                        size: 80,
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Revisa el teu correu',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'T\'hem enviat un enllaç per restablir '
                        'la teva contrasenya a:',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        emailController.text.trim(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 32),

                      FilledButton(
                        onPressed: () => context.go('/'),
                        child: const Text(
                          'Tornar al login',
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_reset,
                        size: 80,
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Recuperar contrasenya',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Introdueix el teu email i t\'enviarem '
                        'un enllaç per crear una nova contrasenya.',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      AuthTextField(
                        controller: emailController,
                        label: 'Email',
                        icon: Icons.email,
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed:
                              _loading
                                  ? null
                                  : _sendResetEmail,
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Enviar correu',
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: _loading
                            ? null
                            : () => context.go('/'),
                        child: const Text(
                          'Tornar al login',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}