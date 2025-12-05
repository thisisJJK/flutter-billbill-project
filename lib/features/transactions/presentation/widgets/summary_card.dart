import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/providers.dart';

/// 잔액 요약 카드 위젯
/// summaryProvider를 사용하여 실제 데이터 표시
class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(summaryProvider);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: summaryAsync.when(
        data: (summary) => Column(
          children: [
            Text(
              '순자산 (받을 돈 - 줄 돈)',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey),
            ),
            const SizedBox(height: 8),
            Text(
              _formatAmount(summary.netBalance),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: summary.netBalance >= 0
                    ? AppColors.primaryGreen
                    : AppColors.primaryRed,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    label: '받을 돈',
                    amount: _formatCurrency(summary.totalLent),
                    color: AppColors.primaryGreen,
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.bgGrey),
                Expanded(
                  child: _buildStatItem(
                    context,
                    label: '줄 돈',
                    amount: _formatCurrency(summary.totalBorrowed),
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ],
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: AppColors.primaryRed),
                const SizedBox(height: 8),
                Text(
                  '데이터를 불러올 수 없습니다',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 금액 포맷 (부호 포함)
  String _formatAmount(int amount) {
    final sign = amount >= 0 ? '+ ' : '- ';
    final absAmount = amount.abs();
    final formatter = NumberFormat('#,###');
    return '$sign${formatter.format(absAmount)}원';
  }

  /// 금액 포맷 (부호 없음)
  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(amount)}원';
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String amount,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textGrey),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
