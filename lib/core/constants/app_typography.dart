import 'package:flutter/material.dart';

/// 앱 전체에서 사용되는 타이포그래피 시스템
/// design_system.md의 Typography 가이드 기반
class AppTypography {
  AppTypography._();

  // ========================================
  // Font Family
  // ========================================

  /// 기본 폰트 (한글 지원)
  static const String defaultFont = 'Pretendard';

  /// 숫자 전용 폰트 (금액 표시용)
  /// 가독성이 좋은 Monospace 계열
  static const String numberFont = 'RobotoMono';

  // ========================================
  // Text Styles (Flutter TextTheme 매핑)
  // ========================================

  /// Display Large (32px, Bold)
  /// 용도: 홈 화면 순잔액, 입력 키패드 금액 표시
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Title Large (20px, Bold)
  /// 용도: 화면 타이틀, 중요 헤딩
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  /// Title Medium (16px, SemiBold)
  /// 용도: 리스트 아이템의 상대방 이름, 앱바 타이틀
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Body Large (16px, Regular)
  /// 용도: 본문 텍스트
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  /// Body Medium (14px, Regular)
  /// 용도: 메모, 일반 텍스트, 설명
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  /// Body Small (12px, Regular)
  /// 용도: 보조 설명, 캡션
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  /// Label Large (14px, Medium)
  /// 용도: 버튼 텍스트
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.1,
  );

  /// Label Medium (12px, Medium)
  /// 용도: 칩 텍스트, 작은 버튼
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Label Small (11px, Medium)
  /// 용도: 하단 캡션, 매우 작은 라벨
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ========================================
  // 금액 표시 전용 스타일
  // ========================================

  /// 큰 금액 표시 (32px, Bold, Monospace)
  /// 용도: 요약 카드, 입력 화면
  static const TextStyle moneyLarge = TextStyle(
    fontFamily: numberFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// 중간 금액 표시 (20px, SemiBold, Monospace)
  /// 용도: 리스트 아이템
  static const TextStyle moneyMedium = TextStyle(
    fontFamily: numberFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// 작은 금액 표시 (16px, Medium, Monospace)
  /// 용도: 상환 히스토리, 작은 금액
  static const TextStyle moneySmall = TextStyle(
    fontFamily: numberFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}
