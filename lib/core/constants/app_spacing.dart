/// 앱 전체에서 사용되는 Spacing 및 Radius 상수
/// design_system.md의 Shapes & Spacing 가이드 기반
class AppSpacing {
  AppSpacing._();

  // ========================================
  // Spacing (여백)
  // ========================================

  /// 매우 작은 여백 (4px)
  static const double xs = 4.0;

  /// 작은 여백 (8px)
  static const double sm = 8.0;

  /// 기본 여백 (12px)
  static const double md = 12.0;

  /// 중간 여백 (16px)
  static const double lg = 16.0;

  /// 큰 여백 (24px)
  static const double xl = 24.0;

  /// 매우 큰 여백 (32px)
  static const double xxl = 32.0;

  /// 초대형 여백 (48px)
  static const double xxxl = 48.0;

  // ========================================
  // Border Radius (모서리 둥글기)
  // ========================================

  /// 버튼 기본 Radius (8px)
  static const double buttonRadius = 8.0;

  /// 버튼 큰 Radius (12px)
  static const double buttonRadiusLarge = 12.0;

  /// 카드 Radius (16px) - 부드러운 느낌
  static const double cardRadius = 16.0;

  /// Bottom Sheet 상단 Radius (20px)
  static const double bottomSheetRadius = 20.0;

  /// Chip Radius (8px)
  static const double chipRadius = 8.0;

  /// Input Field Radius (12px)
  static const double inputRadius = 12.0;

  // ========================================
  // Elevation (그림자 높이)
  // ========================================

  /// 그림자 없음
  static const double elevationNone = 0.0;

  /// 약한 그림자 (1dp)
  static const double elevationLow = 1.0;

  /// 기본 그림자 (2dp) - Summary Card, FAB
  static const double elevationMedium = 2.0;

  /// 강한 그림자 (4dp)
  static const double elevationHigh = 4.0;

  /// 매우 강한 그림자 (8dp) - Modal, Dialog
  static const double elevationVeryHigh = 8.0;

  // ========================================
  // Icon Size
  // ========================================

  /// 작은 아이콘 (16px)
  static const double iconSmall = 16.0;

  /// 기본 아이콘 (24px)
  static const double iconMedium = 24.0;

  /// 큰 아이콘 (32px)
  static const double iconLarge = 32.0;

  /// 매우 큰 아이콘 (48px)
  static const double iconXLarge = 48.0;

  // ========================================
  // Avatar Size
  // ========================================

  /// 작은 아바타 (32px)
  static const double avatarSmall = 32.0;

  /// 기본 아바타 (40px)
  static const double avatarMedium = 40.0;

  /// 큰 아바타 (56px)
  static const double avatarLarge = 56.0;

  /// 매우 큰 아바타 (80px)
  static const double avatarXLarge = 80.0;

  // ========================================
  // Button Height
  // ========================================

  /// 작은 버튼 높이 (36px)
  static const double buttonHeightSmall = 36.0;

  /// 기본 버튼 높이 (48px)
  static const double buttonHeightMedium = 48.0;

  /// 큰 버튼 높이 (56px)
  static const double buttonHeightLarge = 56.0;

  // ========================================
  // Divider
  // ========================================

  /// 구분선 두께
  static const double dividerThickness = 1.0;

  /// 구분선 들여쓰기
  static const double dividerIndent = 16.0;
}
