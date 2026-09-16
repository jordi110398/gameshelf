import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _handleCallback();
  }

  Future<void> _handleCallback() async {
    try {
      final uri = Uri.base;

      debugPrint('AUTH CALLBACK URI: $uri');

      if (uri.queryParameters.containsKey('code')) {
        await Supabase.instance.client.auth.getSessionFromUrl(uri);

        debugPrint('Sessió creada correctament');
      }

      if (!mounted) return;

      final session = Supabase.instance.client.auth.currentSession;

      if (session != null) {
        context.go('/home');
      } else {
        context.go('/');
      }
    } catch (e) {
      debugPrint('ERROR CALLBACK: $e');

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = friendlyError(context, e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(context.l10n.callbackVerifying),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(context.l10n.callbackFailedTitle),
                  const SizedBox(height: 8),
                  Text(
                    _error ?? context.l10n.callbackUnknownError,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.go('/'),
                    child: Text(context.l10n.callbackBackToLogin),
                  ),
                ],
              ),
      ),
    );
  }
}
