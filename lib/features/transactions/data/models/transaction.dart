import 'package:bill_bill/features/transactions/domain/entities/transaction_status.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_type.dart';
import 'package:hive/hive.dart';

part 'transaction.g.dart';

/// 거래 정보 모델
/// PRD 4.5 Hive 데이터 모델 설계 기반
@HiveType(typeId: 2)
class Transaction extends HiveObject {
  /// 거래 고유 ID
  @HiveField(0)
  final String id;

  /// 거래 타입 (빌려준 돈 / 빌린 돈)
  @HiveField(1)
  final TransactionType type;

  /// 상대방 ID
  @HiveField(2)
  final String counterpartyId;

  /// 거래 금액 (원)
  @HiveField(3)
  final int amount;

  /// 통화 (기본: KRW)
  @HiveField(4)
  final String currency;

  /// 거래 날짜
  @HiveField(5)
  final DateTime date;

  /// 거래 상태 (미상환 / 완료)
  @HiveField(6)
  final TransactionStatus status;

  /// 메모
  @HiveField(7)
  final String? notes;

  /// 첨부 파일 경로 리스트 (영수증 등)
  @HiveField(8)
  final List<String> attachments;

  /// 상환 내역 ID 리스트
  @HiveField(9)
  final List<String> paymentIds;

  /// 생성 일시
  @HiveField(10)
  final DateTime createdAt;

  /// 수정 일시
  @HiveField(11)
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.counterpartyId,
    required this.amount,
    this.currency = 'KRW',
    required this.date,
    required this.status,
    this.notes,
    List<String>? attachments,
    List<String>? paymentIds,
    required this.createdAt,
    required this.updatedAt,
  }) : attachments = attachments ?? [],
       paymentIds = paymentIds ?? [];

  /// 남은 금액 계산 (총 금액 - 상환된 금액)
  /// 실제 계산은 Payment 모델과 함께 사용
  int getRemainingAmount(List<int> paidAmounts) {
    final totalPaid = paidAmounts.fold<int>(0, (sum, amount) => sum + amount);
    return amount - totalPaid;
  }

  /// 거래 복사 (수정 시 사용)
  Transaction copyWith({
    String? id,
    TransactionType? type,
    String? counterpartyId,
    int? amount,
    String? currency,
    DateTime? date,
    TransactionStatus? status,
    String? notes,
    List<String>? attachments,
    List<String>? paymentIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      paymentIds: paymentIds ?? this.paymentIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, amount: $amount, status: $status)';
  }
}
