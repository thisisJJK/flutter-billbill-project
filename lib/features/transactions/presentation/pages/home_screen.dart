import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              _buildTransactionList(context, filter: 'all'),
              _buildTransactionList(context, filter: 'lent'),
              _buildTransactionList(context, filter: 'borrowed'),
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

  Widget _buildTransactionList(BuildContext context, {required String filter}) {
    // Dummy Data Generation
    final allItems = List.generate(20, (index) {
      final isLent = index % 2 == 0;
      return {'index': index, 'isLent': isLent};
    });

    final filteredItems = allItems.where((item) {
      if (filter == 'lent') return item['isLent'] == true;
      if (filter == 'borrowed') return item['isLent'] == false;
      return true;
    }).toList();

    if (filteredItems.isEmpty) {
      return const Center(child: Text('거래 내역이 없습니다.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TransactionListItem(
            index: item['index'] as int,
            isLent: item['isLent'] as bool,
          ),
        );
      },
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
