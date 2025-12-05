import 'package:bill_bill/features/transactions/data/models/transaction.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_status.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_type.dart';

/// 거래 Repository 인터페이스
/// Clean Architecture의 Domain Layer에 위치
abstract class TransactionRepository {
  /// 모든 거래 조회
  Future<List<Transaction>> getAllTransactions();

  /// 특정 거래 조회
  Future<Transaction?> getTransactionById(String id);

  /// 거래 타입별 조회
  Future<List<Transaction>> getTransactionsByType(TransactionType type);

  /// 거래 상태별 조회
  Future<List<Transaction>> getTransactionsByStatus(TransactionStatus status);

  /// 상대방별 거래 조회
  Future<List<Transaction>> getTransactionsByCounterparty(
    String counterpartyId,
  );

  /// 거래 추가
  Future<void> addTransaction(Transaction transaction);

  /// 거래 수정
  Future<void> updateTransaction(Transaction transaction);

  /// 거래 삭제
  Future<void> deleteTransaction(String id);

  /// 거래 검색 (상대방 이름, 메모)
  Future<List<Transaction>> searchTransactions(String query);

  /// 날짜 범위로 거래 조회
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// 빌려준 총액 계산
  Future<int> getTotalLent();

  /// 빌린 총액 계산
  Future<int> getTotalBorrowed();

  /// 순 잔액 계산 (빌려준 돈 - 빌린 돈)
  Future<int> getNetBalance();
}
