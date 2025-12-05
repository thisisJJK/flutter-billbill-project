import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../widgets/custom_keypad.dart';

class PartialPaymentScreen extends StatefulWidget {
  final String transactionId;
  final int remainingAmount; // Passed for UI display

  const PartialPaymentScreen({
    super.key,
    required this.transactionId,
    required this.remainingAmount,
  });

  @override
  State<PartialPaymentScreen> createState() => _PartialPaymentScreenState();
}

class _PartialPaymentScreenState extends State<PartialPaymentScreen> {
  String amount = '0';
  String selectedMethod = '현금'; // Default method

  final List<String> paymentMethods = ['현금', '계좌이체', '카드', '기타'];

  void _onKeypadTap(String value) {
    setState(() {
      if (value == 'backspace') {
        if (amount.length > 1) {
          amount = amount.substring(0, amount.length - 1);
        } else {
          amount = '0';
        }
      } else if (value == 'ok') {
        // TODO: Save payment
        context.pop();
      } else {
        if (amount == '0') {
          amount = value;
        } else if (amount.length < 10) {
          amount += value;
        }
      }
    });
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
