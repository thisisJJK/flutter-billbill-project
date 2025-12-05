import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/transaction.dart';
import '../../domain/entities/transaction_type.dart';
import '../providers/providers.dart';

/// 거래 목록 아이템 위젯
/// 실제 Transaction 모델을 받아서 표시
class TransactionListItem extends ConsumerWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionListItem({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLent = transaction.type == TransactionType.lent;

    // 상대방 정보 가져오기
    final counterpartyAsync = ref.watch(
      counterpartyDetailProvider(transaction.counterpartyId),
    );

    // 남은 금액 계산
    final remainingAmountAsync = ref.watch(
      remainingAmountProvider(transaction.id),
    );

    return Dismissible(
      key: ValueKey(transaction.id),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: AppColors.primaryGreen,
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.grey,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              // 상대방 아바타
              counterpartyAsync.when(
                data: (counterparty) => CircleAvatar(
                  backgroundColor: isLent ? AppColors.bgGreen : AppColors.bgRed,
                  child: Text(
                    counterparty?.name.isNotEmpty == true
                        ? counterparty!.name[0]
                        : '?',
                    style: TextStyle(
                      color: isLent
                          ? AppColors.primaryGreen
                          : AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                loading: () => CircleAvatar(
                  backgroundColor: AppColors.bgGrey,
                  child: Icon(Icons.person, color: AppColors.textGrey),
                ),
                error: (_, __) => CircleAvatar(
                  backgroundColor: AppColors.bgGrey,
                  child: Icon(Icons.person, color: AppColors.textGrey),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상대방 이름
                    counterpartyAsync.when(
                      data: (counterparty) => Text(
                        counterparty?.name ?? '알 수 없음',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      loading: () => Text(
                        '로딩 중...',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGrey,
                            ),
                      ),
                      error: (_, __) => Text(
                        '알 수 없음',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 날짜 및 메모
                    Text(
                      '${_formatDate(transaction.date)}${transaction.notes != null ? ' · ${transaction.notes}' : ''}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 금액 (남은 금액 표시)
                  remainingAmountAsync.when(
                    data: (remainingAmount) => Text(
                      _formatCurrency(remainingAmount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isLent
                            ? AppColors.primaryGreen
                            : AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    loading: () => Text(
                      _formatCurrency(transaction.amount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isLent
                            ? AppColors.primaryGreen
                            : AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    error: (_, __) => Text(
                      _formatCurrency(transaction.amount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isLent
                            ? AppColors.primaryGreen
                            : AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 타입 태그
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isLent ? AppColors.bgGreen : AppColors.bgRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isLent ? '빌려줌' : '빌림',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isLent
                            ? AppColors.primaryGreen
                            : AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 날짜 포맷
  String _formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }

  /// 금액 포맷
  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(amount)}원';
  }
}
