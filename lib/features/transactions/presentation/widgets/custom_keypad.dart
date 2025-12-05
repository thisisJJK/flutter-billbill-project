import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';

class CustomKeypad extends StatelessWidget {
  final ValueChanged<String> onTap;
  final Color confirmColor;

  const CustomKeypad({
    super.key,
    required this.onTap,
    required this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgGrey.withOpacity(0.3),
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Column(
        children: [
          Row(children: [_buildKey('1'), _buildKey('2'), _buildKey('3')]),
          Row(children: [_buildKey('4'), _buildKey('5'), _buildKey('6')]),
          Row(children: [_buildKey('7'), _buildKey('8'), _buildKey('9')]),
          Row(
            children: [
              _buildKey('.', label: '.'), // Or '00'
              _buildKey('0'), // 0
              _buildKey('backspace', icon: Icons.backspace_outlined),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onTap('ok');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value, {String? label, IconData? icon}) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap(value);
          },
          child: Container(
            height: 60,
            alignment: Alignment.center,
            child: icon != null
                ? Icon(icon, color: Colors.black)
                : Text(
                    label ?? value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
