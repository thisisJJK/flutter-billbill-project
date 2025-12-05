/// 앱 전체에서 사용되는 문자열 상수
class AppStrings {
  AppStrings._();

  // 앱 정보
  static const String appName = '빌린돈·빌려준돈';
  static const String appDescription = '간편한 정산 관리';

  // 거래 타입
  static const String lent = '빌려준 돈';
  static const String borrowed = '빌린 돈';

  // 공통 액션
  static const String add = '추가';
  static const String edit = '수정';
  static const String delete = '삭제';
  static const String save = '저장';
  static const String cancel = '취소';
  static const String confirm = '확인';
  static const String search = '검색';

  // 거래 관련
  static const String addTransaction = '거래 추가';
  static const String editTransaction = '거래 수정';
  static const String deleteTransaction = '거래 삭제';
  static const String amount = '금액';
  static const String counterparty = '상대방';
  static const String date = '날짜';
  static const String memo = '메모';
  static const String status = '상태';

  // 상환 관련
  static const String partialPayment = '부분 상환';
  static const String fullPayment = '전액 상환';
  static const String paymentHistory = '상환 내역';
  static const String remainingAmount = '남은 금액';

  // 요약
  static const String summary = '요약';
  static const String totalLent = '빌려준 총액';
  static const String totalBorrowed = '빌린 총액';
  static const String netBalance = '순 잔액';

  // 설정
  static const String settings = '설정';
  static const String notifications = '알림';
  static const String backup = '백업';
  static const String export = '내보내기';
  static const String import = '가져오기';

  // 에러 메시지
  static const String errorInvalidAmount = '올바른 금액을 입력해주세요';
  static const String errorEmptyCounterparty = '상대방을 입력해주세요';
  static const String errorExceedingAmount = '상환 금액이 남은 금액을 초과합니다';
}
