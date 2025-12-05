import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class TransactionListItem extends StatelessWidget {
  final int index;
  final bool isLent;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.index,
    required this.isLent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(index),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: AppColors.primaryGreen,
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.grey,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isLent ? AppColors.bgGreen : AppColors.bgRed,
                child: Text(
                  isLent ? '김' : '이',
                  style: TextStyle(
                    color: isLent
                        ? AppColors.primaryGreen
                        : AppColors.primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLent ? '김철수' : '이영희',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '2024.12.05 · 점심값 정산',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isLent ? '20,000원' : '5,000원',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isLent
                          ? AppColors.primaryGreen
                          : AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isLent ? AppColors.bgGreen : AppColors.bgRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isLent ? '빌려줌' : '갚을돈',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isLent
                            ? AppColors.primaryGreen
                            : AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
