import 'package:hive/hive.dart';

part 'transaction_type.g.dart';

/// 거래 타입
/// - lent: 빌려준 돈
/// - borrowed: 빌린 돈
@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  lent, // 빌려준 돈

  @HiveField(1)
  borrowed, // 빌린 돈
}

extension TransactionTypeExtension on TransactionType {
  /// 거래 타입의 한국어 표시명
  String get displayName {
    switch (this) {
      case TransactionType.lent:
        return '빌려준 돈';
      case TransactionType.borrowed:
        return '빌린 돈';
    }
  }

  /// 거래 타입이 빌려준 돈인지 확인
  bool get isLent => this == TransactionType.lent;

  /// 거래 타입이 빌린 돈인지 확인
  bool get isBorrowed => this == TransactionType.borrowed;
}
