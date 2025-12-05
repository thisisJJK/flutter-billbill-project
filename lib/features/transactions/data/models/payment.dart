import 'package:hive/hive.dart';

part 'payment.g.dart';

/// 상환 내역 모델
/// PRD 4.5 Hive 데이터 모델 설계 기반
@HiveType(typeId: 4)
class Payment extends HiveObject {
  /// 상환 내역 고유 ID
  @HiveField(0)
  final String id;

  /// 연관된 거래 ID
  @HiveField(1)
  final String transactionId;

  /// 상환 금액 (원)
  @HiveField(2)
  final int amount;

  /// 상환 날짜
  @HiveField(3)
  final DateTime date;

  /// 결제 방법 (현금, 이체, 카드 등)
  @HiveField(4)
  final String method;

  /// 메모
  @HiveField(5)
  final String? notes;

  /// 생성 일시
  @HiveField(6)
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.method,
    this.notes,
    required this.createdAt,
  });

  /// 상환 내역 복사 (수정 시 사용)
  Payment copyWith({
    String? id,
    String? transactionId,
    int? amount,
    DateTime? date,
    String? method,
    String? notes,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      method: method ?? this.method,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Payment(id: $id, amount: $amount, date: $date)';
  }
}
