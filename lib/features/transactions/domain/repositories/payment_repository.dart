import 'package:bill_bill/features/transactions/data/models/payment.dart';

/// 상환 내역 Repository 인터페이스
/// Clean Architecture의 Domain Layer에 위치
abstract class PaymentRepository {
  /// 모든 상환 내역 조회
  Future<List<Payment>> getAllPayments();

  /// 특정 상환 내역 조회
  Future<Payment?> getPaymentById(String id);

  /// 거래별 상환 내역 조회
  Future<List<Payment>> getPaymentsByTransaction(String transactionId);

  /// 상환 내역 추가
  Future<void> addPayment(Payment payment);

  /// 상환 내역 수정
  Future<void> updatePayment(Payment payment);

  /// 상환 내역 삭제
  Future<void> deletePayment(String id);

  /// 거래의 총 상환 금액 계산
  Future<int> getTotalPaidAmount(String transactionId);
}
