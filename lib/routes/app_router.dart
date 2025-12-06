import 'package:bill_bill/features/transactions/presentation/pages/search_filter_screen.dart';
import 'package:go_router/go_router.dart';

import '../features/settings/presentation/pages/settings_screen.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import '../features/transactions/presentation/pages/add_transaction_screen.dart';
import '../features/transactions/presentation/pages/home_screen.dart';
import '../features/transactions/presentation/pages/partial_payment_screen.dart';
import '../features/transactions/presentation/pages/transaction_detail_screen.dart';

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

        GoRoute(
          path: 'transaction/:id',
          name: 'transactionDetail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TransactionDetailScreen(transactionId: id);
          },
          routes: [
            GoRoute(
              path: 'payment',
              name: 'partialPayment',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                final remainingAmount = state.extra as int? ?? 0;
                return PartialPaymentScreen(
                  transactionId: id,
                  remainingAmount: remainingAmount,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'transaction/:id/edit',
          name: 'editTransaction',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return AddTransactionScreen(transactionId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => SettingsScreen(),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchFilterScreen(),
    ),
  ],
);
