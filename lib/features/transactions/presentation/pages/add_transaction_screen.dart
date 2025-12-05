import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/counterparty.dart';
import '../../data/models/transaction.dart';
import '../../domain/entities/transaction_status.dart';
import '../../domain/entities/transaction_type.dart';
import '../providers/providers.dart';
import '../widgets/custom_keypad.dart';
import '../widgets/transaction_type_selector.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String? transactionId; // If provided, edit mode

  const AddTransactionScreen({super.key, this.transactionId});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late bool isLent;
  String amount = '0';
  Counterparty? selectedCounterparty; // String에서 Counterparty 객체로 변경

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) {
      // TODO: Fetch existing transaction data
      // Mock data for edit mode
      isLent = int.tryParse(widget.transactionId!)?.isEven ?? true;
      amount = '50000';
      // selectedCounterparty는 나중에 실제 데이터에서 로드
    } else {
      isLent = true;
    }
  }

  // ... (existing code)

  Widget _buildCounterpartyInput() {
    return GestureDetector(
      onTap: () async {
        final result = await context.pushNamed<Counterparty>(
          'selectCounterparty',
        );
        if (result != null) {
          setState(() {
            selectedCounterparty = result;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.bgGrey, width: 2)),
        ),
        child: Row(
          children: [
            Icon(
              selectedCounterparty != null ? Icons.person : Icons.person_search,
              color: selectedCounterparty != null
                  ? Colors.black
                  : AppColors.textGrey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedCounterparty?.name ?? '이름 또는 연락처 검색',
                style: TextStyle(
                  color: selectedCounterparty != null
                      ? Colors.black
                      : AppColors.textGrey.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: selectedCounterparty != null
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTypeChanged(bool newValue) {
    setState(() {
      isLent = newValue;
    });
  }

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
            content: Text('금액을 입력해주세요.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryRed,
          ),
        );
        return;
      }

      if (selectedCounterparty == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('상대방을 선택해주세요.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryRed,
          ),
        );
        return;
      }

      try {
        final uuid = const Uuid();
        final now = DateTime.now();
        final counterpartyRepository = ref.read(counterpartyRepositoryProvider);
        final transactionRepository = ref.read(transactionRepositoryProvider);

        // 상대방 정보 저장 (이미 존재하는 경우 스킵)
        final existingCounterparty = await counterpartyRepository
            .getCounterpartyById(selectedCounterparty!.id);
        if (existingCounterparty == null) {
          await counterpartyRepository.addCounterparty(selectedCounterparty!);
        }

        // 거래 정보 생성 및 저장
        final transaction = Transaction(
          id: uuid.v4(),
          type: isLent ? TransactionType.lent : TransactionType.borrowed,
          counterpartyId: selectedCounterparty!.id,
          amount: amountInt,
          currency: 'KRW',
          date: now,
          status: TransactionStatus.open,
          notes: null,
          createdAt: now,
          updatedAt: now,
        );

        await transactionRepository.addTransaction(transaction);

        if (!mounted) return;

        final message = widget.transactionId != null
            ? '거래가 수정되었습니다.'
            : '거래가 저장되었습니다.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
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
          // Limit length
          amount += value;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = isLent ? AppColors.primaryGreen : AppColors.primaryRed;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.transactionId != null ? '거래 수정' : '거래 기록',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TransactionTypeSelector(
              isLent: isLent,
              onChanged: _onTypeChanged,
            ),
          ),
          const Spacer(),
          // Amount Display
          Text(
            '${isLent ? '받을' : '줄'} 금액',
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatAmount(amount),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '원',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Counterparty & Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                _buildCounterpartyInput(),
                const SizedBox(height: 20),
                // Date & Memo (Simplified for UI only)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '오늘 (2025.12.05)',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Keypad
          CustomKeypad(onTap: _onKeypadTap, confirmColor: primaryColor),
        ],
      ),
    );
  }

  String _formatAmount(String value) {
    if (value.isEmpty) return '0';
    // Simple formatter for display
    final number = int.tryParse(value);
    if (number == null) return value;
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
