import 'package:gameshelf/core/router/go_router_refresh_stream.dart';
import 'package:gameshelf/features/auth/login/login_page.dart';
import 'package:gameshelf/features/auth/register/register_page.dart';
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
    final isLogin = state.matchedLocation == "/";
    final isRegister = state.matchedLocation == "/register";

    if (!loggedIn && !isLogin && !isRegister) {
      return "/";
    }

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