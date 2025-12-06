import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/entities/transaction_type.dart';
import '../providers/providers.dart';
import '../widgets/history_timeline.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 거래 정보 가져오기
    final transactionAsync = ref.watch(
      transactionDetailProvider(transactionId),
    );

    // 상환 내역 가져오기
    final paymentsAsync = ref.watch(
      paymentsByTransactionProvider(transactionId),
    );

    // 남은 금액 가져오기
    final remainingAmountAsync = ref.watch(
      remainingAmountProvider(transactionId),
    );

    // 거래 삭제 처리
    Future<void> deleteTransaction() async {
      // 로딩 다이얼로그 표시
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final transactionRepository = ref.read(transactionRepositoryProvider);
        final paymentRepository = ref.read(paymentRepositoryProvider);

        // 관련된 모든 상환 내역 삭제
        final payments = await paymentRepository.getPaymentsByTransaction(
          transactionId,
        );
        for (final payment in payments) {
          await paymentRepository.deletePayment(payment.id);
        }

        // 거래 삭제
        await transactionRepository.deleteTransaction(transactionId);

        if (!context.mounted) return;

        // 로딩 다이얼로그 닫기
        Navigator.of(context).pop();

        // 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('거래가 삭제되었습니다.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryGreen,
          ),
        );

        // 홈 화면으로 이동
        context.go('/home');
      } catch (e) {
        if (!context.mounted) return;

        // 로딩 다이얼로그 닫기
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 중 오류가 발생했습니다: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryRed,
          ),
        );
      }
    }

    // 삭제 확인 다이얼로그 표시
    Future<void> showDeleteConfirmation() async {
      // 거래 정보 가져오기
      final transactionRepository = ref.read(transactionRepositoryProvider);
      final counterpartyRepository = ref.read(counterpartyRepositoryProvider);

      final transaction = await transactionRepository.getTransactionById(
        transactionId,
      );

      if (transaction == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('거래 정보를 불러올 수 없습니다.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryRed,
          ),
        );
        return;
      }

      // 상대방 정보 가져오기
      final counterparty = await counterpartyRepository.getCounterpartyById(
        transaction.counterpartyId,
      );

      if (!context.mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '거래 삭제',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이 거래를 삭제하시겠습니까?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '상대방: ${counterparty?.name ?? '알 수 없음'}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '금액: ${_formatCurrency(transaction.amount)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '⚠️ 관련된 모든 상환 내역도 함께 삭제됩니다.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                '취소',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryRed,
              ),
              child: const Text(
                '삭제',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await deleteTransaction();
      }
    }

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
            onPressed: showDeleteConfirmation,
          ),
        ],
      ),
      body: transactionAsync.when(
        data: (transaction) {
          if (transaction == null) {
            return const Center(child: Text('거래를 찾을 수 없습니다'));
          }

          final isLent = transaction.type == TransactionType.lent;
          final primaryColor = isLent
              ? AppColors.primaryGreen
              : AppColors.primaryRed;

          // 상대방 정보 가져오기
          final counterpartyAsync = ref.watch(
            counterpartyDetailProvider(transaction.counterpartyId),
          );

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 1. Transaction Header
                        counterpartyAsync.when(
                          data: (counterparty) => CircleAvatar(
                            radius: 30,
                            backgroundColor: isLent
                                ? AppColors.bgGreen
                                : AppColors.bgRed,
                            child: Text(
                              counterparty?.name.isNotEmpty == true
                                  ? counterparty!.name[0]
                                  : '?',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          loading: () => const CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.bgGrey,
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: AppColors.textGrey,
                            ),
                          ),
                          error: (_, __) => const CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.bgGrey,
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        counterpartyAsync.when(
                          data: (counterparty) => Text(
                            isLent
                                ? '${counterparty?.name ?? '알 수 없음'}에게 받음'
                                : '${counterparty?.name ?? '알 수 없음'}에게 보냄',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          loading: () => Text(
                            '로딩 중...',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          error: (_, __) => Text(
                            isLent ? '받음' : '보냄',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 남은 금액 표시
                        remainingAmountAsync.when(
                          data: (remainingAmount) => Text(
                            _formatCurrency(remainingAmount),
                            style: AppTypography.displayLarge.copyWith(
                              color: primaryColor,
                            ),
                          ),
                          loading: () => Text(
                            _formatCurrency(transaction.amount),
                            style: AppTypography.displayLarge.copyWith(
                              color: primaryColor,
                            ),
                          ),
                          error: (_, __) => Text(
                            _formatCurrency(transaction.amount),
                            style: AppTypography.displayLarge.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        StatusChip(status: transaction.status),
                        const SizedBox(height: 48),

                        // 2. Timeline
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('히스토리', style: AppTypography.titleMedium),
                        ),
                        const SizedBox(height: 24),
                        paymentsAsync.when(
                          data: (payments) {
                            // 초기 거래 이벤트
                            final events = <TimelineEvent>[
                              TimelineEvent(
                                title: '거래 기록',
                                date: _formatDateTime(transaction.date),
                                amount: _formatCurrency(transaction.amount),
                                type: TimelineEventType.initial,
                                memo: transaction.notes,
                              ),
                            ];

                            // 상환 이벤트 추가
                            for (final payment in payments) {
                              events.add(
                                TimelineEvent(
                                  title: '부분 상환',
                                  date: _formatDateTime(payment.date),
                                  amount: '-${_formatCurrency(payment.amount)}',
                                  type: TimelineEventType.repayment,
                                  memo: payment.notes,
                                ),
                              );
                            }

                            return HistoryTimeline(
                              isLent: isLent,
                              events: events,
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) => HistoryTimeline(
                            isLent: isLent,
                            events: [
                              TimelineEvent(
                                title: '거래 기록',
                                date: _formatDateTime(transaction.date),
                                amount: _formatCurrency(transaction.amount),
                                type: TimelineEventType.initial,
                                memo: transaction.notes,
                              ),
                            ],
                          ),
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
                        color: Colors.black.withValues(alpha: 0.05),
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
                            context.go(
                              '/home/transaction/$transactionId/payment',
                              extra:
                                  remainingAmountAsync.valueOrNull ??
                                  (transaction.amount -
                                      (paymentsAsync.valueOrNull?.fold<int>(
                                            0,
                                            (p, c) => p + c.amount,
                                          ) ??
                                          0)),
                            );
                          },
                          backgroundColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.primaryRed,
              ),
              const SizedBox(height: 16),
              Text(
                '거래 정보를 불러올 수 없습니다',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 금액 포맷
  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(amount)}원';
  }

  /// 날짜/시간 포맷
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
  }
}
