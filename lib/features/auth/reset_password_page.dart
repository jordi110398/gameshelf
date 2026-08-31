import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/features/auth/widgets/auth_text_field.dart';
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final authService = AuthService();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isSaving = false;
  bool _recoveryReady = false;

  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    passwordController.addListener(_onPasswordChanged);
    confirmPasswordController.addListener(_onPasswordChanged);

    _handleRecovery();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();

    passwordController.removeListener(_onPasswordChanged);
    confirmPasswordController.removeListener(_onPasswordChanged);

    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  void _onPasswordChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // ─────────────────────────────────────────────
  // REQUISITS DE CONTRASENYA
  // ─────────────────────────────────────────────

  bool get _hasMinLength {
    return passwordController.text.length >= 8;
  }

  bool get _hasUppercase {
    return RegExp(r'[A-Z]').hasMatch(passwordController.text);
  }

  bool get _hasLowercase {
    return RegExp(r'[a-z]').hasMatch(passwordController.text);
  }

  bool get _hasNumber {
    return RegExp(r'[0-9]').hasMatch(passwordController.text);
  }

  bool get _hasSymbol {
    return RegExp(
      r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]+=]',
    ).hasMatch(passwordController.text);
  }

  bool get _isPasswordValid {
    return _hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasNumber &&
        _hasSymbol;
  }

  bool get _passwordsMatch {
    return passwordController.text == confirmPasswordController.text &&
        confirmPasswordController.text.isNotEmpty;
  }

  // ─────────────────────────────────────────────
  // CANVIAR CONTRASENYA
  // ─────────────────────────────────────────────

  Future<void> _handleRecovery() async {
    try {
      final uri = Uri.base;

      debugPrint('RESET PASSWORD URI: $uri');

      if (uri.queryParameters.containsKey('code')) {
        await Supabase.instance.client.auth.getSessionFromUrl(uri);

        debugPrint('Recovery session creada correctament');
      }

      final session = Supabase.instance.client.auth.currentSession;

      if (session == null) {
        debugPrint('No hi ha sessió de recovery');
      } else {
        debugPrint('Usuari recovery: ${session.user.email}');

        if (mounted) {
          setState(() {
            _recoveryReady = true;
          });
        }
      }
    } catch (e) {
      debugPrint('ERROR RECOVERY: $e');

      if (mounted) {
        setState(() {
          _recoveryReady = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    if (!_isPasswordValid || !_passwordsMatch) {
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'L\'enllaç de recuperació ha caducat. '
            'Torna a sol·licitar el canvi de contrasenya.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await authService.updatePassword(passwordController.text);

      if (!mounted) return;

      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Contrasenya actualitzada'),
            content: const Text(
              'La teva contrasenya s\'ha canviat correctament. '
              'Ara pots iniciar sessió amb la nova contrasenya.',
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.go('/');
                },
                child: const Text('Iniciar sessió'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No s\'ha pogut canviar la contrasenya: ${friendlyError(e)}',
          ),
        ),
      );

      setState(() {
        _isSaving = false;
      });
    }
  }

  // ─────────────────────────────────────────────
  // REQUISIT
  // ─────────────────────────────────────────────

  Widget _buildPasswordRequirement({
    required bool fulfilled,
    required String text,
  }) {
    final password = passwordController.text;

    final color = password.isEmpty
        ? Colors.grey.shade500
        : fulfilled
        ? Colors.green
        : Colors.grey.shade500;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(
            fulfilled ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final showPasswordMismatch =
        confirmPasswordController.text.isNotEmpty && !_passwordsMatch;

    return Scaffold(
      appBar: AppBar(title: const Text('Restablir contrasenya')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_reset, size: 80),

                const SizedBox(height: 24),

                const Text(
                  'Nova contrasenya',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Introdueix una nova contrasenya per al teu compte.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 32),

                AuthTextField(
                  controller: passwordController,
                  label: 'Nova contrasenya',
                  icon: Icons.lock,
                  obscureText: true,
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'La contrasenya ha de tenir:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _buildPasswordRequirement(
                        fulfilled: _hasMinLength,
                        text: 'Almenys 8 caràcters',
                      ),

                      _buildPasswordRequirement(
                        fulfilled: _hasUppercase,
                        text: 'Una lletra majúscula',
                      ),

                      _buildPasswordRequirement(
                        fulfilled: _hasLowercase,
                        text: 'Una lletra minúscula',
                      ),

                      _buildPasswordRequirement(
                        fulfilled: _hasNumber,
                        text: 'Un número',
                      ),

                      _buildPasswordRequirement(
                        fulfilled: _hasSymbol,
                        text: 'Un símbol',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: confirmPasswordController,
                  label: 'Repeteix la contrasenya',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 8),

                if (showPasswordMismatch)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Les contrasenyes no coincideixen.',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed:
                        _recoveryReady &&
                            _isPasswordValid &&
                            _passwordsMatch &&
                            !_isSaving
                        ? _resetPassword
                        : null,
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Canviar contrasenya'),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _isSaving ? null : () => context.go('/'),
                  child: const Text('Tornar a iniciar sessió'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
