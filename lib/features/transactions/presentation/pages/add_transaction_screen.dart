import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/custom_keypad.dart';
import '../widgets/transaction_type_selector.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isLent = true; // true: 빌려준 돈, false: 빌린 돈
  String amount = '0';

  void _onTypeChanged(bool newValue) {
    setState(() {
      isLent = newValue;
    });
  }

  void _onKeypadTap(String value) {
    setState(() {
      if (value == 'backspace') {
        if (amount.length > 1) {
          amount = amount.substring(0, amount.length - 1);
        } else {
          amount = '0';
        }
      } else if (value == 'ok') {
        // TODO: Save transaction
        context.pop();
      } else {
        if (amount == '0') {
          amount = value;
        } else if (amount.length < 10) {
          // Limit length
          amount += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = isLent ? AppColors.primaryGreen : AppColors.primaryRed;
    final bgColor = isLent ? AppColors.bgGreen : AppColors.bgRed;

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
          '거래 기록',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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

  Widget _buildCounterpartyInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.bgGrey, width: 2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_search, color: AppColors.textGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '이름 또는 연락처 검색',
              style: TextStyle(
                color: AppColors.textGrey.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          ),
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
