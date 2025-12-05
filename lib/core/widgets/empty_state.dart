import 'package:bill_bill/core/constants/app_colors.dart';
import 'package:bill_bill/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

/// 빈 상태를 표시하는 위젯
/// design_system.md의 UX Interaction Guideline - Empty States
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  /// 거래 내역이 없을 때
  const EmptyState.noTransactions({super.key, this.action})
    : icon = Icons.receipt_long_outlined,
      title = '아직 거래 내역이 없네요',
      message = '가까운 친구와의 점심값부터\n기록해볼까요?';

  /// 검색 결과가 없을 때
  const EmptyState.noSearchResults({super.key})
    : icon = Icons.search_off,
      title = '검색 결과가 없습니다',
      message = '다른 검색어로 시도해보세요',
      action = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            Icon(icon, size: 80, color: AppColors.textGrey.withOpacity(0.5)),
            const SizedBox(height: AppSpacing.lg),

            // 타이틀
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),

            // 메시지
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // 액션 버튼 (선택적)
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
