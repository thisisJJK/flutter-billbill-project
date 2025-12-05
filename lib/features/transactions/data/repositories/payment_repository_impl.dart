import 'package:bill_bill/features/transactions/data/models/payment.dart';
import 'package:bill_bill/features/transactions/domain/repositories/payment_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Payment Repository 구현 (Hive 기반)
/// Clean Architecture의 Data Layer에 위치
class PaymentRepositoryImpl implements PaymentRepository {
  static const String _boxName = 'payments';

  /// Hive Box 가져오기
  Box<Payment> get _box => Hive.box<Payment>(_boxName);

  @override
  Future<List<Payment>> getAllPayments() async {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // 최신순 정렬
  }

  @override
  Future<Payment?> getPaymentById(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<Payment>> getPaymentsByTransaction(String transactionId) async {
    return _box.values.where((p) => p.transactionId == transactionId).toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // 오래된 순 정렬 (히스토리)
  }

  @override
  Future<void> addPayment(Payment payment) async {
    await _box.put(payment.id, payment);
  }

  @override
  Future<void> updatePayment(Payment payment) async {
    await _box.put(payment.id, payment);
  }

  @override
  Future<void> deletePayment(String id) async {
    await _box.delete(id);
  }

  @override
  Future<int> getTotalPaidAmount(String transactionId) async {
    final payments = await getPaymentsByTransaction(transactionId);
    return payments.fold<int>(0, (sum, payment) => sum + payment.amount);
  }
}
