import 'package:flutter/material.dart';

/// 앱 전체에서 사용되는 색상 상수
/// design_system.md의 이원화된 색상 코드(Dual Color Coding) 기반
class AppColors {
  AppColors._();

  // ========================================
  // 핵심 색상 (Dual Color Coding)
  // ========================================

  /// 빌려준 돈 (Asset/Positive) - 받을 권리
  /// 긍정, 완료, 안정감을 나타냄
  static const Color primaryGreen = Color(0xFF00C853);
  static const Color bgGreen = Color(0xFFE8F5E9);

  /// 빌린 돈 (Liability/Negative) - 갚을 의무
  /// 경고, 긴급, 중요 알림을 나타냄
  static const Color primaryRed = Color(0xFFFF5252);
  static const Color bgRed = Color(0xFFFFEBEE);

  // ========================================
  // 기본 색상 (Base Colors)
  // ========================================

  /// 카드 배경, 바텀시트 배경
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  /// 앱 전체 배경색 (Scaffold Background)
  static const Color bgGrey = Color(0xFFF5F6F8);

  /// 기본 본문, 타이틀
  static const Color textBlack = Color(0xFF212121);

  /// 보조 설명, 날짜, 비활성 텍스트
  static const Color textGrey = Color(0xFF9E9E9E);

  // ========================================
  // 상태 색상 (Status Colors)
  // ========================================

  static const Color success = Color(0xFF00C853); // primaryGreen과 동일
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFFF5252); // primaryRed와 동일
  static const Color info = Color(0xFF42A5F5);

  // ========================================
  // 다크 모드 색상
  // ========================================

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // ========================================
  // 구분선 및 기타
  // ========================================

  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2C2C2C);

  /// Swipe 액션 배경색
  static const Color swipeEdit = Color(0xFFBDBDBD); // Grey
  static const Color swipeComplete = primaryGreen; // 상환 완료
  static const Color swipeDelete = primaryRed; // 삭제
}
