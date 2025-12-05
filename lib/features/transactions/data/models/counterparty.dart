import 'package:hive/hive.dart';

part 'counterparty.g.dart';

/// 상대방 정보 모델
/// PRD 4.5 Hive 데이터 모델 설계 기반
@HiveType(typeId: 3)
class Counterparty extends HiveObject {
  /// 상대방 고유 ID
  @HiveField(0)
  final String id;

  /// 이름
  @HiveField(1)
  final String name;

  /// 전화번호 (선택)
  @HiveField(2)
  final String? phone;

  /// 이메일 (선택)
  @HiveField(3)
  final String? email;

  /// 프로필 이미지 경로 (선택)
  @HiveField(4)
  final String? avatarPath;

  /// 생성 일시
  @HiveField(5)
  final DateTime createdAt;

  /// 수정 일시
  @HiveField(6)
  final DateTime updatedAt;

  Counterparty({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.avatarPath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 상대방 복사 (수정 시 사용)
  Counterparty copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatarPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Counterparty(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Counterparty(id: $id, name: $name)';
  }
}
