import 'package:bill_bill/app.dart';
import 'package:bill_bill/features/transactions/data/models/alarm.dart';
import 'package:bill_bill/features/transactions/data/models/counterparty.dart';
import 'package:bill_bill/features/transactions/data/models/payment.dart';
import 'package:bill_bill/features/transactions/data/models/transaction.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_status.dart';
import 'package:bill_bill/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 앱의 진입점
/// Hive 초기화 및 Riverpod ProviderScope 설정
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await Hive.initFlutter();

  // Hive 어댑터 등록
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionStatusAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CounterpartyAdapter());
  Hive.registerAdapter(PaymentAdapter());
  Hive.registerAdapter(AlarmAdapter());

  // Hive 박스 열기
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<Counterparty>('counterparties');
  await Hive.openBox<Payment>('payments');
  await Hive.openBox<Alarm>('alarms');
  await Hive.openBox('settings');

  runApp(const ProviderScope(child: BillBillApp()));
}
