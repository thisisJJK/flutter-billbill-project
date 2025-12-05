import 'package:bill_bill/features/transactions/data/models/counterparty.dart';
import 'package:bill_bill/features/transactions/domain/repositories/counterparty_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Counterparty Repository 구현 (Hive 기반)
/// Clean Architecture의 Data Layer에 위치
class CounterpartyRepositoryImpl implements CounterpartyRepository {
  static const String _boxName = 'counterparties';

  /// Hive Box 가져오기
  Box<Counterparty> get _box => Hive.box<Counterparty>(_boxName);

  @override
  Future<List<Counterparty>> getAllCounterparties() async {
    return _box.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name)); // 이름순 정렬
  }

  @override
  Future<Counterparty?> getCounterpartyById(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<Counterparty>> searchCounterparties(String query) async {
    final lowercaseQuery = query.toLowerCase();
    return _box.values.where((c) {
      return c.name.toLowerCase().contains(lowercaseQuery);
    }).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<void> addCounterparty(Counterparty counterparty) async {
    await _box.put(counterparty.id, counterparty);
  }

  @override
  Future<void> updateCounterparty(Counterparty counterparty) async {
    await _box.put(counterparty.id, counterparty);
  }

  @override
  Future<void> deleteCounterparty(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<Counterparty>> getRecentCounterparties({int limit = 5}) async {
    final counterparties = _box.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // 최근 수정순
    return counterparties.take(limit).toList();
  }
}
