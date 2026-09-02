import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/core/strings/auth_strings.dart';
import 'package:gameshelf/core/strings/legal_strings.dart';
import 'package:gameshelf/features/auth/widgets/auth_text_field.dart';
import 'package:gameshelf/core/utils/error_messages.dart';

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

  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();

    passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    nicknameController.dispose();
    emailController.dispose();
    passwordController.removeListener(_onPasswordChanged);
    passwordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    setState(() {});
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

  // ─────────────────────────────────────────────
  // REGISTRE
  // ─────────────────────────────────────────────

  Future<void> _register() async {
    if (!_isPasswordValid) return;

    final nickname = nicknameController.text.trim();
    final email = emailController.text.trim();

    if (nickname.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AuthStrings.registerEmptyFields)),
      );
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    try {
      final response = await authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        nickname: nicknameController.text.trim(),
        emailRedirectTo: '${Uri.base.origin}/auth/callback',
      );
      if (response.user == null) {
        throw Exception(AuthStrings.registerUserCreationFailed);
      }

      if (!mounted) return;

      // Amb confirmació de correu activada, no intentem entrar
      // directament a l'aplicació.
      context.go('/email-confirmation', extra: email);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyError(e))));

      setState(() {
        _isRegistering = false;
      });
    }
  }

  // ─────────────────────────────────────────────
  // INDICADOR DE REQUISIT
  // ─────────────────────────────────────────────

  Widget _buildPasswordRequirement({
    required bool fulfilled,
    required String text,
  }) {
    final password = passwordController.text;

    // Mentre no ha començat a escriure, mostrem els requisits en gris.
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
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/logo.png'),
                  width: 96,
                  height: 96,
                ),

                const SizedBox(height: 24),

                const Text(
                  AuthStrings.appName,
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                // ─────────────────────────────
                // NICKNAME
                // ─────────────────────────────
                AuthTextField(
                  controller: nicknameController,
                  label: AuthStrings.registerNicknameLabel,
                  icon: Icons.person,
                ),

                const SizedBox(height: 20),

                // ─────────────────────────────
                // EMAIL
                // ─────────────────────────────
                AuthTextField(
                  controller: emailController,
                  label: AuthStrings.registerEmailLabel,
                  icon: Icons.email,
                ),

                const SizedBox(height: 20),

                // ─────────────────────────────
                // PASSWORD
                // ─────────────────────────────
                AuthTextField(
                  controller: passwordController,
                  label: AuthStrings.registerPasswordLabel,
                  icon: Icons.lock,
                  obscureText: true,
                ),

                const SizedBox(height: 12),

                // ─────────────────────────────
                // REQUISITS
                // ─────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AuthStrings.passwordRequirementsTitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _buildPasswordRequirement(
                        fulfilled: _hasMinLength,
                        text: AuthStrings.passwordReqMinLength,
                      ),

                      _buildPasswordRequirement(
                        fulfilled: _hasUppercase,
                        text: AuthStrings.passwordReqUppercase,
                      ),

                      _buildPasswordRequirement(
                        fulfilled: _hasLowercase,
                        text: AuthStrings.passwordReqLowercase,
                      ),

                      _buildPasswordRequirement(
                        fulfilled: _hasNumber,
                        text: AuthStrings.passwordReqNumber,
                      ),

                      _buildPasswordRequirement(
                        fulfilled: _hasSymbol,
                        text: AuthStrings.passwordReqSymbol,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ─────────────────────────────
                // CREAR COMPTE
                // ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      children: [
                        const TextSpan(text: AuthStrings.registerLegalPrefix),
                        TextSpan(
                          text: LegalStrings.privacyTitle,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push('/legal/privacy'),
                        ),
                        const TextSpan(text: AuthStrings.registerLegalAnd),
                        TextSpan(
                          text: LegalStrings.cookiesTitle,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push('/legal/cookies'),
                        ),
                        const TextSpan(text: AuthStrings.registerLegalSuffix),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isPasswordValid && !_isRegistering
                        ? _register
                        : null,
                    child: _isRegistering
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(AuthStrings.registerSubmit),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _isRegistering ? null : () => context.go("/"),
                  child: const Text(AuthStrings.registerAlreadyHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
