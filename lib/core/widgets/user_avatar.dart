import 'package:bill_bill/core/constants/app_colors.dart';
import 'package:bill_bill/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

/// 상대방 프로필 아바타 위젯
/// design_system.md의 Atoms - Avatar
///
/// 특징:
/// - 이미지가 없을 경우 이름 첫 글자 + 랜덤 파스텔 배경 표시
/// - 다양한 크기 지원 (small, medium, large, xlarge)
class UserAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;

  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = AppSpacing.avatarMedium,
  });

  /// 작은 아바타 (32px)
  const UserAvatar.small({super.key, required this.name, this.imageUrl})
    : size = AppSpacing.avatarSmall;

  /// 기본 아바타 (40px)
  const UserAvatar.medium({super.key, required this.name, this.imageUrl})
    : size = AppSpacing.avatarMedium;

  /// 큰 아바타 (56px)
  const UserAvatar.large({super.key, required this.name, this.imageUrl})
    : size = AppSpacing.avatarLarge;

  /// 매우 큰 아바타 (80px)
  const UserAvatar.xlarge({super.key, required this.name, this.imageUrl})
    : size = AppSpacing.avatarXLarge;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // 이미지가 있는 경우
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: _getBackgroundColor(name),
      );
    } else {
      // 이미지가 없는 경우: 이름 첫 글자 표시
      final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
      final fontSize = size * 0.4; // 아바타 크기의 40%

      return CircleAvatar(
        radius: size / 2,
        backgroundColor: _getBackgroundColor(name),
        child: Text(
          initial,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      );
    }
  }

  /// 이름 기반 파스텔 배경색 생성
  /// 같은 이름은 항상 같은 색상을 반환
  Color _getBackgroundColor(String name) {
    final pastelColors = [
      const Color(0xFFFFCDD2), // Red
      const Color(0xFFF8BBD0), // Pink
      const Color(0xFFE1BEE7), // Purple
      const Color(0xFFD1C4E9), // Deep Purple
      const Color(0xFFC5CAE9), // Indigo
      const Color(0xFFBBDEFB), // Blue
      const Color(0xFFB3E5FC), // Light Blue
      const Color(0xFFB2EBF2), // Cyan
      const Color(0xFFB2DFDB), // Teal
      const Color(0xFFC8E6C9), // Green
      const Color(0xFFDCEDC8), // Light Green
      const Color(0xFFF0F4C3), // Lime
      const Color(0xFFFFF9C4), // Yellow
      const Color(0xFFFFECB3), // Amber
      const Color(0xFFFFE0B2), // Orange
      const Color(0xFFFFCCBC), // Deep Orange
    ];

    // 이름의 해시코드를 사용하여 색상 선택
    final index = name.hashCode.abs() % pastelColors.length;
    return pastelColors[index];
  }
}
