import 'package:bill_bill/features/transactions/data/models/counterparty.dart';

/// 상대방 Repository 인터페이스
/// Clean Architecture의 Domain Layer에 위치
abstract class CounterpartyRepository {
  /// 모든 상대방 조회
  Future<List<Counterparty>> getAllCounterparties();

  /// 특정 상대방 조회
  Future<Counterparty?> getCounterpartyById(String id);

  /// 상대방 검색 (이름)
  Future<List<Counterparty>> searchCounterparties(String query);

  /// 상대방 추가
  Future<void> addCounterparty(Counterparty counterparty);

  /// 상대방 수정
  Future<void> updateCounterparty(Counterparty counterparty);

  /// 상대방 삭제
  Future<void> deleteCounterparty(String id);

  /// 최근 사용한 상대방 조회 (자동완성용)
  Future<List<Counterparty>> getRecentCounterparties({int limit = 5});
}
