import 'package:bill_bill/features/transactions/data/models/counterparty.dart';
import 'package:bill_bill/features/transactions/presentation/providers/repositories_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 모든 상대방 목록 Provider (실시간 업데이트)
final allCounterpartiesProvider = StreamProvider<List<Counterparty>>((ref) {
  final box = Hive.box<Counterparty>('counterparties');

  return box.watch().map((_) {
    return box.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name)); // 이름순 정렬
  });
});

/// 특정 상대방 상세 Provider (ID 기반)
final counterpartyDetailProvider = FutureProvider.family<Counterparty?, String>(
  (ref, id) async {
    final repository = ref.watch(counterpartyRepositoryProvider);
    return await repository.getCounterpartyById(id);
  },
);

/// 상대방 검색 Provider
final searchCounterpartiesProvider =
    FutureProvider.family<List<Counterparty>, String>((ref, query) async {
      if (query.isEmpty) {
        // 검색어가 없으면 모든 상대방 반환
        final repository = ref.watch(counterpartyRepositoryProvider);
        return await repository.getAllCounterparties();
      }
      final repository = ref.watch(counterpartyRepositoryProvider);
      return await repository.searchCounterparties(query);
    });

/// 최근 사용한 상대방 목록 Provider
final recentCounterpartiesProvider = FutureProvider<List<Counterparty>>((
  ref,
) async {
  final repository = ref.watch(counterpartyRepositoryProvider);
  return await repository.getRecentCounterparties(limit: 5);
});
