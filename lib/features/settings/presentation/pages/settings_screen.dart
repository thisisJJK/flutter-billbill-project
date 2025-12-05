import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.bgGrey,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSectionHeader('일반'),
          _buildListTile(
            icon: Icons.notifications_outlined,
            title: '알림 설정',
            onTap: () {
              // TODO: Navigate to Notification Settings
            },
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('데이터'),
          _buildListTile(
            icon: Icons.cloud_upload_outlined,
            title: '백업 및 복원',
            subtitle: 'CSV 파일 내보내기/가져오기',
            onTap: () {
              // TODO: Navigate to Backup Screen
            },
          ),
          _buildListTile(
            icon: Icons.security,
            title: '잠금 설정',
            subtitle: '앱 실행 시 생체인증 사용',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // TODO: Toggle Lock
              },
              activeThumbColor: AppColors.primaryGreen,
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('정보'),
          _buildListTile(
            icon: Icons.info_outline,
            title: '앱 버전',
            trailing: const Text(
              '1.0.0',
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
          _buildListTile(
            icon: Icons.privacy_tip_outlined,
            title: '개인정보 처리방침',
            onTap: () {
              // TODO: Open Privacy Policy
            },
          ),
          _buildListTile(
            icon: Icons.description_outlined,
            title: '오픈소스 라이선스',
            onTap: () {
              // TODO: Open Licenses
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textGrey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textBlack),
        title: Text(title, style: AppTypography.bodyMedium),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textGrey,
                ),
              )
            : null,
        trailing:
            trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textGrey,
            ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
