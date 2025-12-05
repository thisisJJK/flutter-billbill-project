import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class TransactionTypeSelector extends StatelessWidget {
  final bool isLent;
  final ValueChanged<bool> onChanged;

  const TransactionTypeSelector({
    super.key,
    required this.isLent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.bgGrey,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: isLent
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: constraints.maxWidth / 2,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: isLent
                        ? AppColors.primaryGreen
                        : AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isLent
                                    ? AppColors.primaryGreen
                                    : AppColors.primaryRed)
                                .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(true),
                      behavior: HitTestBehavior.translucent,
                      child: Center(
                        child: Text(
                          '빌려준 돈',
                          style: TextStyle(
                            color: isLent ? Colors.white : AppColors.textGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(false),
                      behavior: HitTestBehavior.translucent,
                      child: Center(
                        child: Text(
                          '빌린 돈',
                          style: TextStyle(
                            color: !isLent ? Colors.white : AppColors.textGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
