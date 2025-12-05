import 'package:bill_bill/features/transactions/data/models/payment.dart';
import 'package:bill_bill/features/transactions/presentation/providers/repositories_provider.dart';
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

/// 특정 거래의 상환 내역 Provider
final paymentsByTransactionProvider =
    FutureProvider.family<List<Payment>, String>((ref, transactionId) async {
      final repository = ref.watch(paymentRepositoryProvider);
      return await repository.getPaymentsByTransaction(transactionId);
    });

/// 특정 거래의 총 상환 금액 Provider
final totalPaidAmountProvider = FutureProvider.family<int, String>((
  ref,
  transactionId,
) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return await repository.getTotalPaidAmount(transactionId);
});

/// 특정 거래의 남은 금액 계산 Provider
/// 원래 거래 금액에서 상환된 금액을 뺀 값
final remainingAmountProvider = FutureProvider.family<int, String>((
  ref,
  transactionId,
) async {
  // 거래 정보 가져오기
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final transaction = await transactionRepo.getTransactionById(transactionId);

  if (transaction == null) {
    return 0;
  }

  // 총 상환 금액 가져오기
  final paymentRepo = ref.watch(paymentRepositoryProvider);
  final totalPaid = await paymentRepo.getTotalPaidAmount(transactionId);

  // 남은 금액 계산
  return transaction.amount - totalPaid;
});
