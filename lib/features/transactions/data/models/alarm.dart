import 'package:hive/hive.dart';

part 'alarm.g.dart';

/// 알림 설정 모델
/// PRD 4.5 Hive 데이터 모델 설계 기반
@HiveType(typeId: 5)
class Alarm extends HiveObject {
  /// 알림 고유 ID
  @HiveField(0)
  final String id;

  /// 연관된 거래 ID
  @HiveField(1)
  final String transactionId;

  /// 알림 예정 일시
  @HiveField(2)
  final DateTime schedule;

  /// 반복 설정 (once, daily, weekly, monthly 등)
  @HiveField(3)
  final String repeat;

  /// 알림 활성화 여부
  @HiveField(4)
  final bool enabled;

  /// 생성 일시
  @HiveField(5)
  final DateTime createdAt;

  /// 수정 일시
  @HiveField(6)
  final DateTime updatedAt;

  Alarm({
    required this.id,
    required this.transactionId,
    required this.schedule,
    this.repeat = 'once',
    this.enabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 알림 복사 (수정 시 사용)
  Alarm copyWith({
    String? id,
    String? transactionId,
    DateTime? schedule,
    String? repeat,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Alarm(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      schedule: schedule ?? this.schedule,
      repeat: repeat ?? this.repeat,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Alarm(id: $id, schedule: $schedule, enabled: $enabled)';
  }
}
