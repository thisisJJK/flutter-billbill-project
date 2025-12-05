import 'package:bill_bill/features/transactions/data/repositories/counterparty_repository_impl.dart';
import 'package:bill_bill/features/transactions/data/repositories/payment_repository_impl.dart';
import 'package:bill_bill/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:bill_bill/features/transactions/domain/repositories/counterparty_repository.dart';
import 'package:bill_bill/features/transactions/domain/repositories/payment_repository.dart';
import 'package:bill_bill/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Transaction Repository Provider
/// Riverpod을 통해 Repository 인스턴스 제공
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl();
});

/// Counterparty Repository Provider
final counterpartyRepositoryProvider = Provider<CounterpartyRepository>((ref) {
  return CounterpartyRepositoryImpl();
});

/// Payment Repository Provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl();
});
