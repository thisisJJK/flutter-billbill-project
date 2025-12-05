import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/presentation/pages/splash_screen.dart';
import '../features/transactions/presentation/pages/add_transaction_screen.dart';
import '../features/transactions/presentation/pages/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'add',
          name: 'addTransaction',
          builder: (context, state) => const AddTransactionScreen(),
        ),
      ],
    ),
  ],
);
