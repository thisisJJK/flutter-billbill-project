import 'package:async/async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/payment.dart';
import '../../data/models/transaction.dart';
import '../../domain/entities/transaction_status.dart';
import '../../domain/entities/transaction_type.dart';

/// 잔액 요약 데이터 모델
class SummaryData {
  final int totalLent; // 빌려준 총액
  final int totalBorrowed; // 빌린 총액
  final int netBalance; // 순 잔액 (빌려준 돈 - 빌린 돈)

  SummaryData({
    required this.totalLent,
    required this.totalBorrowed,
    required this.netBalance,
  });

  /// 빈 데이터 생성
  factory SummaryData.empty() {
    return SummaryData(totalLent: 0, totalBorrowed: 0, netBalance: 0);
  }
}

/// 잔액 요약 Provider
/// 빌려준 돈, 빌린 돈, 순 잔액을 계산하여 제공 (실시간 업데이트)
final summaryProvider = StreamProvider<SummaryData>((ref) async* {
  final transactionBox = Hive.box<Transaction>('transactions');
  final paymentBox = Hive.box<Payment>('payments');

  // 데이터 계산 함수
  SummaryData calculateSummary() {
    int totalLent = 0;
    int totalBorrowed = 0;

    final transactions = transactionBox.values.where(
      (t) => t.status == TransactionStatus.open,
    );

    for (var transaction in transactions) {
      final payments = paymentBox.values.where(
        (p) => p.transactionId == transaction.id,
      );
      final paidAmount = payments.fold<int>(0, (sum, p) => sum + p.amount);
      final remainingAmount = transaction.amount - paidAmount;

      if (transaction.type == TransactionType.lent) {
        totalLent += remainingAmount;
      } else {
        totalBorrowed += remainingAmount;
      }
    }

    return SummaryData(
      totalLent: totalLent,
      totalBorrowed: totalBorrowed,
      netBalance: totalLent - totalBorrowed,
    );
  }

  // 초기 데이터 emit
  yield calculateSummary();

  // 변경사항 감지 스트림 병합
  final combinedStream = StreamGroup.merge([
    transactionBox.watch(),
    paymentBox.watch(),
  ]);

  await for (final _ in combinedStream) {
    yield calculateSummary();
  }
});

/// 빌려준 총액 Provider (Stream)
final totalLentProvider = StreamProvider<int>((ref) async* {
  final summaryAsync = ref.watch(summaryProvider);
  yield summaryAsync.valueOrNull?.totalLent ?? 0;
});

/// 빌린 총액 Provider (Stream)
final totalBorrowedProvider = StreamProvider<int>((ref) async* {
  final summaryAsync = ref.watch(summaryProvider);
  yield summaryAsync.valueOrNull?.totalBorrowed ?? 0;
});

/// 순 잔액 Provider (Stream)
final netBalanceProvider = StreamProvider<int>((ref) async* {
  final summaryAsync = ref.watch(summaryProvider);
  yield summaryAsync.valueOrNull?.netBalance ?? 0;
});
