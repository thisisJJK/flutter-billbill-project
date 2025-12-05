import 'package:bill_bill/core/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/providers.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_list_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: AppColors.bgGrey,
                elevation: 0,
                title: Text(
                  'BillBill',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: AppColors.textBlack),
                    onPressed: () {
                      context.push('/search');
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textBlack,
                    ),
                    onPressed: () {
                      context.push('/settings');
                    },
                  ),
                ],
                centerTitle: false,
                floating: true,
                snap: true,
                forceElevated: innerBoxIsScrolled,
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: SummaryCard(),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  child: Container(
                    color: AppColors.bgGrey,
                    child: const TabBar(
                      labelColor: AppColors.textBlack,
                      unselectedLabelColor: AppColors.textGrey,
                      indicatorColor: AppColors.textBlack,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(text: '전체'),
                        Tab(text: '빌려준 돈'),
                        Tab(text: '빌린 돈'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildTransactionList(context, ref, filter: 'all'),
              _buildTransactionList(context, ref, filter: 'lent'),
              _buildTransactionList(context, ref, filter: 'borrowed'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/home/add');
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    WidgetRef ref, {
    required String filter,
  }) {
    // Provider 선택 (필터에 따라)
    final transactionsAsyncValue = filter == 'lent'
        ? ref.watch(lentTransactionsProvider)
        : filter == 'borrowed'
        ? ref.watch(borrowedTransactionsProvider)
        : ref.watch(allTransactionsProvider);

    return transactionsAsyncValue.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return const EmptyStateWidget(
            message: '거래 내역이 없습니다.\n새로운 거래를 추가해보세요!',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TransactionListItem(
                transaction: transaction,
                onTap: () {
                  context.go('/home/transaction/${transaction.id}');
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.primaryRed,
            ),
            const SizedBox(height: 16),
            Text(
              '데이터를 불러올 수 없습니다',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
