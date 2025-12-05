import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

enum TimelineEventType { initial, repayment }

class TimelineEvent {
  final String title;
  final String date;
  final String amount;
  final TimelineEventType type;
  final String? memo;
  final bool isComplete;

  TimelineEvent({
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
    this.memo,
    this.isComplete = false,
  });
}

class HistoryTimeline extends StatelessWidget {
  final List<TimelineEvent> events;
  final bool isLent;

  const HistoryTimeline({
    super.key,
    required this.events,
    required this.isLent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: events.asMap().entries.map((entry) {
        final index = entry.key;
        final event = entry.value;
        final isLast = index == events.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Line & Dot
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: event.isComplete
                            ? (isLent
                                  ? AppColors.primaryGreen
                                  : AppColors.primaryRed)
                            : Colors.white,
                        border: Border.all(
                          color: isLent
                              ? AppColors.primaryGreen
                              : AppColors.primaryRed,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.textGrey.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event.title,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            event.amount,
                            style: AppTypography.bodyMedium.copyWith(
                              color: event.type == TimelineEventType.repayment
                                  ? (isLent
                                        ? AppColors.primaryGreen
                                        : AppColors.primaryRed)
                                  : AppColors.textBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.date,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                      if (event.memo != null && event.memo!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            event.memo!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
