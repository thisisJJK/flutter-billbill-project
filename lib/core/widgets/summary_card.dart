import 'package:bill_bill/core/constants/app_colors.dart';
import 'package:bill_bill/core/constants/app_spacing.dart';
import 'package:bill_bill/core/constants/app_typography.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter/material.dart';

/// 총 받을 돈 / 총 갚을 돈 / 순자산을 보여주는 요약 카드
/// design_system.md의 Organisms - Summary Card (Dashboard Hero)
///
/// 특징:
/// - Gradient 배경으로 시각적 강조
/// - 3가지 데이터 표시 (빌려준 총액, 빌린 총액, 순잔액)
class SummaryCard extends StatelessWidget {
  final int totalLent; // 빌려준 총액
  final int totalBorrowed; // 빌린 총액

  const SummaryCard({
    super.key,
    required this.totalLent,
    required this.totalBorrowed,
  });

  /// 순잔액 계산 (빌려준 돈 - 빌린 돈)
  int get netBalance => totalLent - totalBorrowed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withOpacity(0.1),
            AppColors.primaryGreen.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀
          const Text(
            '잔액 요약',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 순잔액 (메인)
          _buildNetBalance(),
          const SizedBox(height: AppSpacing.lg),

          // 구분선
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.lg),

          // 빌려준 돈 / 빌린 돈
          Row(
            children: [
              Expanded(
                child: _buildAmountItem(
                  label: '빌려준 돈',
                  amount: totalLent,
                  type: TransactionType.lent,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _buildAmountItem(
                  label: '빌린 돈',
                  amount: totalBorrowed,
                  type: TransactionType.borrowed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 순잔액 표시
  Widget _buildNetBalance() {
    final isPositive = netBalance >= 0;
    final color = isPositive ? AppColors.primaryGreen : AppColors.primaryRed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '순 잔액',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Text(
              isPositive ? '+' : '-',
              style: AppTypography.displayLarge.copyWith(color: color),
            ),
            const SizedBox(width: 4),
            Text(
              '₩${_formatAmount(netBalance.abs())}',
              style: AppTypography.displayLarge.copyWith(color: color),
            ),
          ],
        ),
      ],
    );
  }

  /// 금액 항목 표시
  Widget _buildAmountItem({
    required String label,
    required int amount,
    required TransactionType type,
  }) {
    final color = type.isLent ? AppColors.primaryGreen : AppColors.primaryRed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '₩${_formatAmount(amount)}',
          style: AppTypography.moneyMedium.copyWith(color: color),
        ),
      ],
    );
  }

  /// 금액 포맷팅 (3자리 콤마)
  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
