import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_colors.dart';
import 'routes/app_router.dart';

class BillBillApp extends ConsumerWidget {
  const BillBillApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'BillBill App',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.bgGrey,
        primaryColor: AppColors.primaryGreen,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgGrey,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
