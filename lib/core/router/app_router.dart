import 'package:flutter/material.dart';
import 'package:gameshelf/core/router/go_router_refresh_stream.dart';

import 'package:gameshelf/features/auth/login/login_page.dart';
import 'package:gameshelf/features/auth/register/register_page.dart';
import 'package:gameshelf/features/auth/register/email_confirmation_page.dart';
import 'package:gameshelf/features/auth/auth_callback_page.dart';
import 'package:gameshelf/features/auth/forgot_password_page.dart';
import 'package:gameshelf/features/auth/reset_password_page.dart';

import 'package:gameshelf/features/home/home_page.dart';
import 'package:gameshelf/features/profile/profile_page.dart';
import 'package:gameshelf/features/search/search_page.dart';

import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final appRouter = GoRouter(
  initialLocation: "/",

  refreshListenable: GoRouterRefreshStream(
    supabase.auth.onAuthStateChange,
  ),

  redirect: (context, state) {
    final loggedIn = supabase.auth.currentSession != null;
    final location = state.matchedLocation;

    final isLogin = location == "/";
    final isRegister = location == "/register";
    final isEmailConfirmation = location == "/email-confirmation";
    final isForgotPassword = location == "/forgot-password";
    final isResetPassword = location == "/auth/reset-password";
    final isAuthCallback = location == "/auth/callback";

    final isAuthRoute =
        isLogin ||
        isRegister ||
        isEmailConfirmation ||
        isForgotPassword ||
        isResetPassword ||
        isAuthCallback;

    // Si no està autenticat, només pot accedir
    // a les rutes d'autenticació.
    if (!loggedIn && !isAuthRoute) {
      return "/";
    }

    // Si està autenticat i intenta anar al login o registre,
    // el portem a home.
    if (loggedIn && (isLogin || isRegister)) {
      return "/home";
    }

    return null;
  },

  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: "/register",
      builder: (context, state) => const RegisterPage(),
    ),

    GoRoute(
      path: "/email-confirmation",
      builder: (context, state) {
        final email = state.extra as String;

        return EmailConfirmationPage(
          email: email,
        );
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
      builder: (context, state) => const HomePage(),
    ),

    GoRoute(
      path: "/profile",
      builder: (context, state) => const ProfilePage(),
    ),

    GoRoute(
      path: "/search",
      builder: (context, state) => const SearchPage(),
    ),
  ],
);