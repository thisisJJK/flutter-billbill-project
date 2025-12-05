import 'package:bill_bill/core/constants/app_colors.dart';
import 'package:bill_bill/core/constants/app_typography.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 금액 표기 전용 위젯
/// design_system.md의 Atoms - Money Text
///
/// 특징:
/// - Monospace 폰트 사용 (숫자 가독성 향상)
/// - 3자리 콤마 필수
/// - 거래 타입에 따른 색상 자동 적용
class MoneyText extends StatelessWidget {
  final int amount;
  final TransactionType? type;
  final TextStyle? style;
  final bool showCurrency;
  final bool showSign;

  const MoneyText({
    super.key,
    required this.amount,
    this.type,
    this.style,
    this.showCurrency = true,
    this.showSign = false,
  });

  /// 큰 금액 표시용 (32px)
  const MoneyText.large({
    super.key,
    required this.amount,
    this.type,
    this.showCurrency = true,
    this.showSign = false,
  }) : style = AppTypography.moneyLarge;

  /// 중간 금액 표시용 (20px)
  const MoneyText.medium({
    super.key,
    required this.amount,
    this.type,
    this.showCurrency = true,
    this.showSign = false,
  }) : style = AppTypography.moneyMedium;

  /// 작은 금액 표시용 (16px)
  const MoneyText.small({
    super.key,
    required this.amount,
    this.type,
    this.showCurrency = true,
    this.showSign = false,
  }) : style = AppTypography.moneySmall;

  @override
  Widget build(BuildContext context) {
    // 금액 포맷팅 (3자리 콤마)
    final formatter = NumberFormat('#,###');
    final formattedAmount = formatter.format(amount.abs());

    // 부호 결정
    String sign = '';
    if (showSign && amount != 0) {
      sign = amount > 0 ? '+' : '-';
    }

    // 통화 기호
    final currency = showCurrency ? '₩' : '';

    // 색상 결정 (거래 타입에 따라)
    Color textColor = AppColors.textBlack;
    if (type != null) {
      textColor = type!.isLent ? AppColors.primaryGreen : AppColors.primaryRed;
    }

    return Text(
      '$sign$currency$formattedAmount',
      style: (style ?? AppTypography.moneyMedium).copyWith(color: textColor),
    );
  }
}
