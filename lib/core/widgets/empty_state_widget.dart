import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.bgGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.assignment_outlined,
              size: 48,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textGrey,
              fontSize: 16,
            ),
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: PrimaryButton(
                text: buttonText!,
                onPressed: onButtonPressed!,
                backgroundColor: AppColors.primaryGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
