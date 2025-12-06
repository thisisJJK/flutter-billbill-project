import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/counterparty.dart';
import '../../data/models/transaction.dart';
import '../../domain/entities/transaction_status.dart';
import '../../domain/entities/transaction_type.dart';
import '../providers/providers.dart';
import '../widgets/custom_keypad.dart';
import '../widgets/transaction_type_selector.dart';

enum AddTransactionStep { amount, details }

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String? transactionId;

  const AddTransactionScreen({super.key, this.transactionId});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  AddTransactionStep _currentStep = AddTransactionStep.amount;
  late bool isLent;
  String amount = '0';
  final TextEditingController _counterpartyController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  DateTime _selectedDate = DateTime.now();
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    isLent = true;

    // 수정 모드인 경우 데이터 로드는 build에서 처리
    if (widget.transactionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadTransactionData();
      });
    }
  }

  /// 기존 거래 데이터 로드
  Future<void> _loadTransactionData() async {
    if (widget.transactionId == null || _isDataLoaded) return;

    try {
      final transactionRepository = ref.read(transactionRepositoryProvider);
      final transaction = await transactionRepository.getTransactionById(
        widget.transactionId!,
      );

      if (transaction == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('거래를 찾을 수 없습니다.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryRed,
          ),
        );
        context.pop();
        return;
      }

      // 상대방 정보 로드
      final counterpartyRepository = ref.read(counterpartyRepositoryProvider);
      final counterparty = await counterpartyRepository.getCounterpartyById(
        transaction.counterpartyId,
      );

      if (!mounted) return;

      // 거래 데이터로 폼 필드 초기화
      setState(() {
        isLent = transaction.type == TransactionType.lent;
        amount = transaction.amount.toString();
        _selectedDate = transaction.date;
        _noteController.text = transaction.notes ?? '';
        if (counterparty != null) {
          _counterpartyController.text = counterparty.name;
        }
        _isDataLoaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('거래 정보를 불러올 수 없습니다: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primaryRed,
        ),
      );
    }
  }

  @override
  void dispose() {
    _counterpartyController.dispose();
    _noteController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTypeChanged(bool newValue) {
    setState(() {
      isLent = newValue;
    });
  }

  void _onKeypadTap(String value) {
    if (value == 'backspace') {
      setState(() {
        if (amount.length > 1) {
          amount = amount.substring(0, amount.length - 1);
        } else {
          amount = '0';
        }
      });
    } else if (value == 'ok') {
      final amountInt = int.tryParse(amount);
      if (amountInt == null || amountInt <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('금액을 입력해주세요.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryRed,
          ),
        );
        return;
      }
      setState(() {
        _currentStep = AddTransactionStep.details;
      });
    } else {
      setState(() {
        if (amount == '0') {
          amount = value;
        } else if (amount.length < 10) {
          amount += value;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: isLent ? AppColors.primaryGreen : AppColors.primaryRed,
              onPrimary: Colors.white,
              onSurface: AppColors.textBlack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: isLent
                    ? AppColors.primaryGreen
                    : AppColors.primaryRed,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitTransaction() async {
    final counterpartyName = _counterpartyController.text.trim();
    if (counterpartyName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('상대방 이름을 입력해주세요.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    try {
      final uuid = const Uuid();
      final now = DateTime.now();
      final counterpartyRepository = ref.read(counterpartyRepositoryProvider);
      final transactionRepository = ref.read(transactionRepositoryProvider);

      Counterparty counterparty;
      final existingCounterparties = await counterpartyRepository
          .getAllCounterparties();
      final matchingCounterparties = existingCounterparties
          .where((c) => c.name == counterpartyName)
          .toList();

      if (matchingCounterparties.isNotEmpty) {
        counterparty = matchingCounterparties.first;
      } else {
        counterparty = Counterparty(
          id: uuid.v4(),
          name: counterpartyName,
          createdAt: now,
          updatedAt: now,
        );
        await counterpartyRepository.addCounterparty(counterparty);
      }

      // 수정 모드인 경우 기존 거래 정보 가져오기
      if (widget.transactionId != null) {
        final existingTransaction = await transactionRepository
            .getTransactionById(widget.transactionId!);

        if (existingTransaction == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('거래를 찾을 수 없습니다.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.primaryRed,
            ),
          );
          return;
        }

        // 기존 거래 정보를 유지하면서 수정된 필드만 업데이트
        final updatedTransaction = existingTransaction.copyWith(
          type: isLent ? TransactionType.lent : TransactionType.borrowed,
          counterpartyId: counterparty.id,
          amount: int.parse(amount),
          date: _selectedDate,
          notes: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          updatedAt: now,
        );

        await transactionRepository.updateTransaction(updatedTransaction);
      } else {
        // 새 거래 생성
        final transaction = Transaction(
          id: uuid.v4(),
          type: isLent ? TransactionType.lent : TransactionType.borrowed,
          counterpartyId: counterparty.id,
          amount: int.parse(amount),
          currency: 'KRW',
          date: _selectedDate,
          status: TransactionStatus.open,
          notes: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          createdAt: now,
          updatedAt: now,
        );

        await transactionRepository.addTransaction(transaction);
      }

      if (!mounted) return;

      final message = widget.transactionId != null
          ? '거래가 수정되었습니다.'
          : '거래가 저장되었습니다.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('저장 중 오류가 발생했습니다: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primaryRed,
        ),
      );
    }
  }

  Widget _buildStepOne() {
    final primaryColor = isLent ? AppColors.primaryGreen : AppColors.primaryRed;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TransactionTypeSelector(
                  isLent: isLent,
                  onChanged: _onTypeChanged,
                ),
                const SizedBox(height: 48),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text('${isLent ? '받을' : '줄'} 금액'),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                            fontFamily: 'Inter',
                          ),
                          child: Text(_formatAmount(amount)),
                        ),
                        const SizedBox(width: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          child: const Text('원'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CustomKeypad(
          onTap: _onKeypadTap,
          confirmColor: primaryColor,
          submitLabel: '다음',
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    final primaryColor = isLent ? AppColors.primaryGreen : AppColors.primaryRed;
    return Column(
      children: [
        // Summary Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                '${isLent ? '받을' : '줄'} 금액',
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _formatAmount(amount),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '원',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              children: [
                _buildCounterpartyInput(),
                const SizedBox(height: 16),
                _buildDateInput(),
                const SizedBox(height: 16),
                _buildNoteInput(),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _submitTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '저장하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCounterpartyInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bgGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textGrey,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _counterpartyController,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                hintText: '누구와 거래했나요?',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                color: AppColors.textBlack,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.textGrey,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  DateFormat(
                    'yyyy년 MM월 dd일 (E)',
                    'ko_KR',
                  ).format(_selectedDate),
                  style: const TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bgGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: AppColors.textGrey,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _noteController,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                hintText: '메모를 남겨보세요',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                color: AppColors.textBlack,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == AddTransactionStep.amount,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep == AddTransactionStep.details) {
          setState(() {
            _currentStep = AddTransactionStep.amount;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgGrey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: _currentStep == AddTransactionStep.amount
              ? AppColors.bgGrey
              : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors
                    .white, // Step 2 헤더가 white라 겹칠 수 있으나 leading은 보통 투명하지 않음
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _currentStep == AddTransactionStep.details
                    ? Icons.arrow_back
                    : Icons.close,
                color: AppColors.textBlack,
                size: 20,
              ),
            ),
            onPressed: () {
              if (_currentStep == AddTransactionStep.details) {
                setState(() {
                  _currentStep = AddTransactionStep.amount;
                });
              } else {
                context.pop();
              }
            },
          ),
          title: Text(
            widget.transactionId != null ? '거래 수정' : '새로운 거래',
            style: const TextStyle(
              color: AppColors.textBlack,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _currentStep == AddTransactionStep.amount
                ? _buildStepOne()
                : _buildStepTwo(),
          ),
        ),
      ),
    );
  }

  String _formatAmount(String value) {
    if (value.isEmpty) return '0';
    final number = int.tryParse(value);
    if (number == null) return value;
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
