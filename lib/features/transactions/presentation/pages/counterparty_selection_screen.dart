import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';

class CounterpartySelectionScreen extends StatefulWidget {
  const CounterpartySelectionScreen({super.key});

  @override
  State<CounterpartySelectionScreen> createState() =>
      _CounterpartySelectionScreenState();
}

class _CounterpartySelectionScreenState
    extends State<CounterpartySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentCounterparties = [
    '김철수',
    '이영희',
    '박지민',
    '최수지',
    '정우성',
  ];
  List<String> _filteredCounterparties = [];

  @override
  void initState() {
    super.initState();
    _filteredCounterparties = _recentCounterparties;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredCounterparties = _recentCounterparties
          .where(
            (name) =>
                name.contains(_searchController.text) ||
                _searchController.text.isEmpty,
          )
          .toList();
    });
  }

  void _selectCounterparty(String name) {
    context.pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: const [Icon(Icons.close, color: Colors.black)],
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '상대방 선택',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '이름 또는 연락처 검색',
                prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.bgGrey,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Contact Permission (Mock)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.bgGreen.withOpacity(0.3),
            child: Row(
              children: [
                const Icon(
                  Icons.contacts,
                  size: 20,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  '연락처 연동하고 친구 찾기',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.primaryGreen,
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              itemCount: _filteredCounterparties.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final name = _filteredCounterparties[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.bgGrey,
                    child: Text(
                      name[0],
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(name, style: AppTypography.bodyMedium),
                  onTap: () => _selectCounterparty(name),
                );
              },
            ),
          ),

          // Add Button (if searching new name)
          if (_searchController.text.isNotEmpty &&
              !_filteredCounterparties.contains(_searchController.text))
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                text: '"${_searchController.text}" 추가하기',
                onPressed: () => _selectCounterparty(_searchController.text),
              ),
            ),
        ],
      ),
    );
  }
}
