import 'package:bill_bill/features/transactions/data/models/transaction.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_type.dart';
import 'package:bill_bill/features/transactions/presentation/providers/repositories_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 모든 거래 목록 Provider (실시간 업데이트)
/// Hive Box의 변경사항을 Stream으로 감지하여 자동 업데이트
final allTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final box = Hive.box<Transaction>('transactions');

  // Hive Box의 변경사항을 Stream으로 변환
  return box.watch().map((_) {
    return box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // 최신순 정렬
  });
});

/// 빌려준 돈 목록 Provider
final lentTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final box = Hive.box<Transaction>('transactions');

  return box.watch().map((_) {
    return box.values.where((t) => t.type == TransactionType.lent).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  });
});

/// 빌린 돈 목록 Provider
final borrowedTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final box = Hive.box<Transaction>('transactions');

  return box.watch().map((_) {
    return box.values.where((t) => t.type == TransactionType.borrowed).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  });
});

/// 특정 거래 상세 Provider (ID 기반)
final transactionDetailProvider = FutureProvider.family<Transaction?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getTransactionById(id);
});

/// 거래 검색 Provider
final searchTransactionsProvider =
    FutureProvider.family<List<Transaction>, String>((ref, query) async {
      if (query.isEmpty) {
        return [];
      }
      final repository = ref.watch(transactionRepositoryProvider);
      return await repository.searchTransactions(query);
    });
