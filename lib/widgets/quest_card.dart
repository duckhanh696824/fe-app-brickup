import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_colors.dart';
import '../models/quest.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback onComplete;

  const QuestCard({
    super.key,
    required this.quest,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: quest.isCompleted
                ? AppColors.success.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: quest.isCompleted
            ? Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          // Quest Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: quest.isCompleted
                  ? AppColors.success.withValues(alpha: 0.1)
                  : quest.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              quest.isCompleted ? Icons.check_rounded : quest.icon,
              color: quest.isCompleted ? AppColors.success : quest.color,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          // Quest Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (quest.type == QuestType.fixed)
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'DAILY',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        quest.title,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: quest.isCompleted ? AppColors.success : AppColors.textPrimary,
                          decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  quest.description,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 6,
                        percent: quest.progressPercent,
                        backgroundColor: AppColors.xpBarBackground.withValues(alpha: 0.5),
                        progressColor: quest.isCompleted ? AppColors.success : quest.color,
                        barRadius: const Radius.circular(3),
                        padding: EdgeInsets.zero,
                        animation: true,
                        animationDuration: 500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${quest.progress}/${quest.target}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // XP & Action
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: quest.isCompleted
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${quest.xpReward}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: quest.isCompleted ? AppColors.success : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (!quest.isCompleted)
                GestureDetector(
                  onTap: onComplete,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                  ),
                ),
              if (quest.isCompleted)
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
            ],
          ),
        ],
      ),
    );
  }
}
