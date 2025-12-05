import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo placeholder or Text
            const Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: AppColors.surfaceWhite,
            ),
            const SizedBox(height: 20),
            Text(
              'BillBill',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.surfaceWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '간편한 정산 관리',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.surfaceWhite.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
