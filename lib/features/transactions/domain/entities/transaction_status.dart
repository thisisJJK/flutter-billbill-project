import 'package:hive/hive.dart';

part 'transaction_status.g.dart';

/// 거래 상태
/// - open: 미상환 (진행 중)
/// - closed: 완전 상환 (완료)
@HiveType(typeId: 1)
enum TransactionStatus {
  @HiveField(0)
  open, // 미상환

  @HiveField(1)
  closed, // 완전 상환
}

extension TransactionStatusExtension on TransactionStatus {
  /// 거래 상태의 한국어 표시명
  String get displayName {
    switch (this) {
      case TransactionStatus.open:
        return '미상환';
      case TransactionStatus.closed:
        return '완료';
    }
  }

  /// 거래가 진행 중인지 확인
  bool get isOpen => this == TransactionStatus.open;

  /// 거래가 완료되었는지 확인
  bool get isClosed => this == TransactionStatus.closed;
}
