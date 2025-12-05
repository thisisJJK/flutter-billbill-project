import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Filters
  String _selectedType = 'all'; // all, lent, borrowed
  String _selectedStatus = 'all'; // all, open, completed

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '이름, 메모 검색',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColors.textGrey),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.textGrey),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.bgGrey)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('전체', 'all', _selectedType, (val) {
                    setState(() => _selectedType = val);
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip('빌려준 돈', 'lent', _selectedType, (val) {
                    setState(() => _selectedType = val);
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip('빌린 돈', 'borrowed', _selectedType, (val) {
                    setState(() => _selectedType = val);
                  }),
                  Container(
                    width: 1,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: AppColors.bgGrey,
                  ),
                  _buildFilterChip('전체 상태', 'all', _selectedStatus, (val) {
                    setState(() => _selectedStatus = val);
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip('정산 중', 'open', _selectedStatus, (val) {
                    setState(() => _selectedStatus = val);
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip('완료', 'completed', _selectedStatus, (val) {
                    setState(() => _selectedStatus = val);
                  }),
                ],
              ),
            ),
          ),

          // Results (Placeholder)
          Expanded(
            child: _searchController.text.isEmpty
                ? Center(
                    child: Text(
                      '검색어를 입력해주세요.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String groupValue,
    Function(String) onSelected,
  ) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textBlack : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.textBlack : AppColors.bgGrey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textGrey,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
