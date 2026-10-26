import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../widgets/quest_card.dart';
import '../../widgets/xp_header.dart';

class SoloScreen extends StatelessWidget {
  const SoloScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final profile = appState.profile;
        final quests = appState.dailyQuests;
        final completedCount = quests.where((q) => q.isCompleted).length;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Solo Mode',
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Hoàn thành quest để nhận XP!',
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 13,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                                // Rank Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        profile.currentRank.emoji,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        profile.currentRank.label,
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // XP Progress
                            XpHeader(profile: profile),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Daily Quest Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.today_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nhiệm Vụ Hôm Nay',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '$completedCount/${quests.length} hoàn thành',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Penalty warning
                      if (completedCount == 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning),
                              const SizedBox(width: 4),
                              Text(
                                '-15 XP',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // All complete bonus
                      if (completedCount == quests.length)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stars_rounded, size: 14, color: AppColors.success),
                              const SizedBox(width: 4),
                              Text(
                                '+30 XP',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
                ),
              ),

              // Quest Cards
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final quest = quests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: QuestCard(
                          quest: quest,
                          onComplete: () {
                            appState.completeQuestProgress(quest.id);
                          },
                        ).animate(delay: Duration(milliseconds: 100 * index))
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut),
                      );
                    },
                    childCount: quests.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
