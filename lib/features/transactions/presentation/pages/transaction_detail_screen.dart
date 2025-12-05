import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/entities/transaction_status.dart';
import '../widgets/history_timeline.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final bool isLent =
        int.tryParse(transactionId)?.isEven ?? true; // ID 짝수면 빌려준 돈
    final primaryColor = isLent ? AppColors.primaryGreen : AppColors.primaryRed;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () {
              context.pushNamed(
                'editTransaction',
                pathParameters: {'id': transactionId},
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () {
              // Show Delete Confirmation
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Transaction Header
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.bgGrey,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isLent ? '김철수에게 받음' : '이영희에게 보냄',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '50,000원',
                      style: AppTypography.displayLarge.copyWith(
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const StatusChip(status: TransactionStatus.open),
                    const SizedBox(height: 48),

                    // 2. Timeline
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('히스토리', style: AppTypography.titleMedium),
                    ),
                    const SizedBox(height: 24),
                    HistoryTimeline(
                      isLent: isLent,
                      events: [
                        TimelineEvent(
                          title: '거래 기록',
                          date: '2025.12.01 14:30',
                          amount: '50,000원',
                          type: TimelineEventType.initial,
                          memo: '점심값 더치페이',
                        ),
                        TimelineEvent(
                          title: '부분 상환',
                          date: '2025.12.03 10:00',
                          amount: '-10,000원',
                          type: TimelineEventType.repayment,
                          memo: '먼저 만원 보냄',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: '상환하기',
                      onPressed: () {
                        context.go('/home/transaction/$transactionId/payment');
                      },
                      backgroundColor: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
