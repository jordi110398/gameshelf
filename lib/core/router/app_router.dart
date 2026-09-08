import 'package:gameshelf/core/router/go_router_refresh_stream.dart';

import 'package:gameshelf/features/auth/login/login_page.dart';
import 'package:gameshelf/features/auth/register/register_page.dart';
import 'package:gameshelf/features/auth/register/email_confirmation_page.dart';
import 'package:gameshelf/features/auth/auth_callback_page.dart';
import 'package:gameshelf/features/auth/forgot_password_page.dart';
import 'package:gameshelf/features/auth/reset_password_page.dart';

import 'package:gameshelf/features/shell/main_shell_page.dart';
import 'package:gameshelf/features/search/search_page.dart';
import 'package:gameshelf/features/legal/about_page.dart';
import 'package:gameshelf/features/legal/privacy_policy_page.dart';
import 'package:gameshelf/features/legal/cookies_policy_page.dart';

import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// Destinació temptada mentre l'usuari no estava autenticat (p. ex. un
// enllaç de "Compartir perfil" amb `?u=nickname`), perquè es pugui
// recuperar just després d'iniciar sessió en lloc de perdre-la i anar
// sempre a "/home" a seques.
String? _pendingDeepLink;

final appRouter = GoRouter(
  initialLocation: "/",

  refreshListenable: GoRouterRefreshStream(supabase.auth.onAuthStateChange),

  redirect: (context, state) {
    final loggedIn = supabase.auth.currentSession != null;
    final location = state.matchedLocation;

    final isLogin = location == "/";
    final isRegister = location == "/register";
    final isEmailConfirmation = location == "/email-confirmation";
    final isForgotPassword = location == "/forgot-password";
    final isResetPassword = location == "/auth/reset-password";
    final isAuthCallback = location == "/auth/callback";
    final isAbout = location == "/about";
    final isLegal = location.startsWith("/legal/");

    final isAuthRoute =
        isLogin ||
        isRegister ||
        isEmailConfirmation ||
        isForgotPassword ||
        isResetPassword ||
        isAuthCallback ||
        isAbout ||
        isLegal;

    // Si no està autenticat, només pot accedir
    // a les rutes d'autenticació. Guardem on volia anar per recuperar-ho
    // just després d'iniciar sessió.
    if (!loggedIn && !isAuthRoute) {
      _pendingDeepLink = state.uri.toString();
      return "/";
    }

    // Si està autenticat i intenta anar al login o registre,
    // el portem a home (o a la destinació que tenia pendent).
    if (loggedIn && (isLogin || isRegister)) {
      final pending = _pendingDeepLink;
      _pendingDeepLink = null;

      return pending ?? "/home";
    }

    return null;
  },

  routes: [
    GoRoute(path: "/", builder: (context, state) => const LoginPage()),

    GoRoute(
      path: "/register",
      builder: (context, state) => const RegisterPage(),
    ),

    GoRoute(
      path: "/email-confirmation",
      builder: (context, state) {
        final email = state.extra as String;

        return EmailConfirmationPage(email: email);
      },
    ),

    GoRoute(
      path: "/auth/callback",
      builder: (context, state) => const AuthCallbackPage(),
    ),

    GoRoute(
      path: "/forgot-password",
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    GoRoute(
      path: "/auth/reset-password",
      builder: (context, state) => const ResetPasswordPage(),
    ),

    GoRoute(
      path: "/home",
      builder: (context, state) {
        final searchNickname = state.uri.queryParameters['u'];

        return MainShellPage(initialSearchNickname: searchNickname);
      },
    ),

    GoRoute(path: "/search", builder: (context, state) => const SearchPage()),

    GoRoute(path: "/about", builder: (context, state) => const AboutPage()),

    GoRoute(
      path: "/legal/privacy",
      builder: (context, state) => const PrivacyPolicyPage(),
    ),

    GoRoute(
      path: "/legal/cookies",
      builder: (context, state) => const CookiesPolicyPage(),
    ),
  ],
);
