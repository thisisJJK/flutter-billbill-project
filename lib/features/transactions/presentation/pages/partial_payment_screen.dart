import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/models/payment.dart';
import '../../domain/entities/transaction_status.dart';
import '../providers/providers.dart';
import '../widgets/custom_keypad.dart';

class PartialPaymentScreen extends ConsumerStatefulWidget {
  final String transactionId;
  final int remainingAmount; // Passed for UI display

  const PartialPaymentScreen({
    super.key,
    required this.transactionId,
    required this.remainingAmount,
  });

  @override
  ConsumerState<PartialPaymentScreen> createState() =>
      _PartialPaymentScreenState();
}

class _PartialPaymentScreenState extends ConsumerState<PartialPaymentScreen> {
  String amount = '0';
  String selectedMethod = '현금'; // Default method

  final List<String> paymentMethods = ['현금', '계좌이체', '카드', '기타'];

  void _onKeypadTap(String value) async {
    if (value == 'backspace') {
      setState(() {
        if (amount.length > 1) {
          amount = amount.substring(0, amount.length - 1);
        } else {
          amount = '0';
        }
      });
    } else if (value == 'ok') {
      // 유효성 검사
      final amountInt = int.tryParse(amount);
      if (amountInt == null || amountInt <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('상환할 금액을 입력해주세요.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryRed,
          ),
        );
        return;
      }

      if (amountInt > widget.remainingAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '남은 금액(${_formatByCurrency(widget.remainingAmount)}원)을 초과할 수 없습니다.',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryRed,
          ),
        );
        return;
      }

      try {
        final uuid = const Uuid();
        final now = DateTime.now();
        final paymentRepository = ref.read(paymentRepositoryProvider);
        final transactionRepository = ref.read(transactionRepositoryProvider);

        // Payment 객체 생성 및 저장
        final payment = Payment(
          id: uuid.v4(),
          transactionId: widget.transactionId,
          amount: amountInt,
          date: now,
          method: selectedMethod,
          notes: null,
          createdAt: now,
        );

        await paymentRepository.addPayment(payment);

        // Transaction 업데이트
        final transaction = await transactionRepository.getTransactionById(
          widget.transactionId,
        );
        if (transaction != null) {
          // paymentIds에 새 Payment ID 추가
          final updatedPaymentIds = [...transaction.paymentIds, payment.id];

          // 총 상환 금액 계산
          final totalPaid = await paymentRepository.getTotalPaidAmount(
            widget.transactionId,
          );

          // 총 상환 금액이 거래 금액과 같으면 상태를 closed로 변경
          final newStatus = totalPaid >= transaction.amount
              ? TransactionStatus.closed
              : transaction.status;

          final updatedTransaction = transaction.copyWith(
            paymentIds: updatedPaymentIds,
            status: newStatus,
            updatedAt: now,
          );

          await transactionRepository.updateTransaction(updatedTransaction);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('상환이 완료되었습니다.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        context.pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 중 오류가 발생했습니다: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryRed,
          ),
        );
      }
    } else {
      setState(() {
        if (amount == '0') {
          amount = value;
        } else if (amount.length < 10) {
          amount += value;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsedAmount = int.tryParse(amount) ?? 0;
    // Just assuming Lent for color for now, or we can pass it as arg
    // But usually payment is "paying back", so it implies action.
    // If I lent money, I am receiving payment. If I borrowed, I am sending payment.
    // Let's use Green as primary for "Money transaction" or keep context.
    // For simplicity, let's stick to Green as "Action" color or use neutral.
    // Let's use PrimaryGreen for now as it is positive action (settling debt).
    const primaryColor = AppColors.primaryGreen;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '상환하기',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Remaining Amount Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bgGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '남은 금액: ${_formatByCurrency(widget.remainingAmount)}원',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),

          const Spacer(),

          // Amount Display
          Text(
            '상환할 금액',
            style: AppTypography.titleMedium.copyWith(color: primaryColor),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatByCurrency(parsedAmount),
                style: AppTypography.displayLarge.copyWith(color: primaryColor),
              ),
              Text(
                '원',
                style: AppTypography.titleLarge.copyWith(color: primaryColor),
              ),
            ],
          ),

          const Spacer(),

          // Payment Method Selector
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: paymentMethods.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                final isSelected = method == selectedMethod;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMethod = method;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : AppColors.bgGrey,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? primaryColor : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      method,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Keypad
          CustomKeypad(onTap: _onKeypadTap, confirmColor: primaryColor),
        ],
      ),
    );
  }

  String _formatByCurrency(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
