import 'package:bill_bill/core/constants/app_colors.dart';
import 'package:bill_bill/core/constants/app_spacing.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_status.dart';
import 'package:flutter/material.dart';

/// 거래 상태를 나타내는 작은 태그 위젯
/// design_system.md의 Atoms - Status Chip
class StatusChip extends StatelessWidget {
  final TransactionStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isOpen = status.isOpen;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isOpen
            ? AppColors.bgGreen.withOpacity(0.5)
            : AppColors.textGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isOpen ? AppColors.primaryGreen : AppColors.textGrey,
          decoration: isOpen ? null : TextDecoration.lineThrough,
        ),
      ),
    );
  }
}
