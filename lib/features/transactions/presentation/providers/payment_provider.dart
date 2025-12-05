import 'package:async/async.dart';
import 'package:bill_bill/features/transactions/data/models/payment.dart';
import 'package:bill_bill/features/transactions/data/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 모든 상환 내역 Provider (실시간 업데이트)
final allPaymentsProvider = StreamProvider<List<Payment>>((ref) async* {
  final box = Hive.box<Payment>('payments');

  // 초기 데이터 emit
  yield box.values.toList()..sort((a, b) => b.date.compareTo(a.date));

  // 이후 변경사항 감지
  await for (final _ in box.watch()) {
    yield box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
});

/// 특정 거래의 상환 내역 Provider (실시간 업데이트)
final paymentsByTransactionProvider =
    StreamProvider.family<List<Payment>, String>((ref, transactionId) async* {
      final box = Hive.box<Payment>('payments');

      // 초기 데이터 emit
      yield box.values.where((p) => p.transactionId == transactionId).toList()
        ..sort((a, b) => a.date.compareTo(b.date)); // 오래된 순 정렬 (히스토리)

      // 이후 변경사항 감지
      await for (final _ in box.watch()) {
        yield box.values.where((p) => p.transactionId == transactionId).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      }
    });

/// 특정 거래의 총 상환 금액 Provider (실시간 업데이트)
final totalPaidAmountProvider = StreamProvider.family<int, String>((
  ref,
  transactionId,
) async* {
  final box = Hive.box<Payment>('payments');

  // 초기 데이터 emit
  final initialPayments = box.values
      .where((p) => p.transactionId == transactionId)
      .toList();
  yield initialPayments.fold<int>(0, (sum, payment) => sum + payment.amount);

  // 이후 변경사항 감지
  await for (final _ in box.watch()) {
    final payments = box.values
        .where((p) => p.transactionId == transactionId)
        .toList();
    yield payments.fold<int>(0, (sum, payment) => sum + payment.amount);
  }
});

/// 특정 거래의 남은 금액 계산 Provider (실시간 업데이트)
/// 원래 거래 금액에서 상환된 금액을 뺀 값
final remainingAmountProvider = StreamProvider.family<int, String>((
  ref,
  transactionId,
) async* {
  // 거래 정보 가져오기
  final transactionBox = Hive.box<Transaction>('transactions');
  final paymentBox = Hive.box<Payment>('payments');

  int calculateRemaining() {
    final transaction = transactionBox.get(transactionId);
    if (transaction == null) {
      return 0;
    }

    final payments = paymentBox.values
        .where((p) => p.transactionId == transactionId)
        .toList();
    final totalPaid = payments.fold<int>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    return transaction.amount - totalPaid;
  }

  // 초기 데이터 emit
  yield calculateRemaining();

  // 변경사항 감지 스트림 병합
  final combinedStream = StreamGroup.merge([
    transactionBox.watch(),
    paymentBox.watch(),
  ]);

  await for (final _ in combinedStream) {
    yield calculateRemaining();
  }
});
