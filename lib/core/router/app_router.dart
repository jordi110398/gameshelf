import 'package:go_router/go_router.dart';

import 'package:gameshelf/features/home/home_page.dart';
import 'package:gameshelf/features/auth/login/login_page.dart';
import 'package:gameshelf/features/auth/register/register_page.dart';
import 'package:gameshelf/features/profile/profile_page.dart';
import 'package:gameshelf/features/search/search_page.dart';

final appRouter = GoRouter(
  initialLocation: "/",

  routes: [

    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
    ),

    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: "/register",
      builder: (context, state) => const RegisterPage(),
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