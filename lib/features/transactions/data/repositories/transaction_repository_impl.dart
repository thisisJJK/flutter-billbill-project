import 'package:bill_bill/features/transactions/data/models/transaction.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_status.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_type.dart';
import 'package:bill_bill/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Transaction Repository 구현 (Hive 기반)
/// Clean Architecture의 Data Layer에 위치
class TransactionRepositoryImpl implements TransactionRepository {
  static const String _boxName = 'transactions';

  /// Hive Box 가져오기
  Box<Transaction> get _box => Hive.box<Transaction>(_boxName);

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // 최신순 정렬
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    return _box.values.firstWhere(
      (transaction) => transaction.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );
  }

  @override
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    return _box.values.where((t) => t.type == type).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Transaction>> getTransactionsByStatus(
    TransactionStatus status,
  ) async {
    return _box.values.where((t) => t.status == status).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Transaction>> getTransactionsByCounterparty(
    String counterpartyId,
  ) async {
    return _box.values.where((t) => t.counterpartyId == counterpartyId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<Transaction>> searchTransactions(String query) async {
    final lowercaseQuery = query.toLowerCase();
    return _box.values.where((t) {
      final notes = t.notes?.toLowerCase() ?? '';
      return notes.contains(lowercaseQuery);
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return _box.values.where((t) {
      return t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<int> getTotalLent() async {
    return _box.values
        .where(
          (t) =>
              t.type == TransactionType.lent &&
              t.status == TransactionStatus.open,
        )
        .fold<int>(0, (sum, t) => sum + t.amount);
  }

  @override
  Future<int> getTotalBorrowed() async {
    return _box.values
        .where(
          (t) =>
              t.type == TransactionType.borrowed &&
              t.status == TransactionStatus.open,
        )
        .fold<int>(0, (sum, t) => sum + t.amount);
  }

  @override
  Future<int> getNetBalance() async {
    final totalLent = await getTotalLent();
    final totalBorrowed = await getTotalBorrowed();
    return totalLent - totalBorrowed;
  }
}
