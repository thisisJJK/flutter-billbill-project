import 'package:bill_bill/features/transactions/presentation/providers/repositories_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 잔액 요약 데이터 모델
class SummaryData {
  final int totalLent; // 빌려준 총액
  final int totalBorrowed; // 빌린 총액
  final int netBalance; // 순 잔액 (빌려준 돈 - 빌린 돈)

  SummaryData({
    required this.totalLent,
    required this.totalBorrowed,
    required this.netBalance,
  });

  /// 빈 데이터 생성
  factory SummaryData.empty() {
    return SummaryData(totalLent: 0, totalBorrowed: 0, netBalance: 0);
  }
}

/// 잔액 요약 Provider
/// 빌려준 돈, 빌린 돈, 순 잔액을 계산하여 제공
final summaryProvider = FutureProvider<SummaryData>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);

  try {
    final totalLent = await repository.getTotalLent();
    final totalBorrowed = await repository.getTotalBorrowed();
    final netBalance = await repository.getNetBalance();

    return SummaryData(
      totalLent: totalLent,
      totalBorrowed: totalBorrowed,
      netBalance: netBalance,
    );
  } catch (e) {
    // 에러 발생 시 빈 데이터 반환
    return SummaryData.empty();
  }
});

/// 빌려준 총액 Provider
final totalLentProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getTotalLent();
});

/// 빌린 총액 Provider
final totalBorrowedProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getTotalBorrowed();
});

/// 순 잔액 Provider
final netBalanceProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getNetBalance();
});
