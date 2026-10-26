import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../services/rank_service.dart';
import '../../models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final profile = appState.profile;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Profile Header
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                      child: Column(
                        children: [
                          // Settings row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Profile',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.settings_rounded, color: Colors.white, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Avatar with rank border
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: profile.currentRank.color, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: profile.currentRank.color.withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 42,
                                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 40,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: profile.currentRank.color,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text(profile.currentRank.emoji, style: const TextStyle(fontSize: 14)),
                              ),
                            ],
                          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 14),
                          Text(
                            profile.name,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: profile.currentRank.color.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${profile.currentRank.emoji} ${profile.currentRank.label} • ${profile.totalXP} XP',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // XP to next rank
                          if (profile.nextRank != null) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${profile.currentRank.emoji} ${profile.currentRank.label}',
                                  style: GoogleFonts.beVietnamPro(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 140,
                                  child: LinearPercentIndicator(
                                    lineHeight: 8,
                                    percent: profile.rankProgress,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    progressColor: Colors.white,
                                    barRadius: const Radius.circular(4),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${profile.nextRank!.emoji} ${profile.nextRank!.label}',
                                  style: GoogleFonts.beVietnamPro(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Còn ${profile.xpToNextRank} XP để lên ${profile.nextRank!.label}',
                              style: GoogleFonts.beVietnamPro(fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Text(
                    'Thống Kê',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(Icons.photo_camera_rounded, '${profile.totalPhotos}', 'Tổng ảnh', AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(Icons.local_fire_department_rounded, '${profile.currentStreak}', 'Streak', AppColors.warning),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(Icons.check_circle_rounded, '${profile.questsCompleted}', 'Quests', AppColors.success),
                      ),
                    ],
                  ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                ),
              ),

              // Badges Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    children: [
                      Text(
                        'Huy Hiệu',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Xem tất cả',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBadge('🌈', 'Color\nFinder', true),
                      _buildBadge('📷', 'First\nChain', true),
                      _buildBadge('🔥', '7-Day\nStreak', false),
                      _buildBadge('🏆', 'Month\nChamp', false),
                      _buildBadge('🎯', 'Full\nQuest', false),
                    ],
                  ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
                ),
              ),

              // Rank List
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Text(
                    'Bảng Xếp Hạng',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final rank = Rank.values[index];
                      final isCurrentRank = rank == profile.currentRank;
                      final isAchieved = profile.totalXP >= rank.requiredXP;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isCurrentRank
                                ? rank.color.withValues(alpha: 0.1)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: isCurrentRank
                                ? Border.all(color: rank.color.withValues(alpha: 0.4), width: 2)
                                : null,
                            boxShadow: isCurrentRank
                                ? [BoxShadow(color: rank.color.withValues(alpha: 0.15), blurRadius: 12)]
                                : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)],
                          ),
                          child: Row(
                            children: [
                              Text(rank.emoji, style: TextStyle(fontSize: 24, color: isAchieved ? null : AppColors.textLight)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rank.label,
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isAchieved ? AppColors.textPrimary : AppColors.textLight,
                                      ),
                                    ),
                                    Text(
                                      RankService.getRankDescription(rank),
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 11,
                                        color: isAchieved ? AppColors.textSecondary : AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${rank.requiredXP} XP',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isAchieved ? rank.color : AppColors.textLight,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isAchieved ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                                color: isAchieved ? AppColors.success : AppColors.textLight,
                                size: 20,
                              ),
                            ],
                          ),
                        ).animate(delay: Duration(milliseconds: 500 + index * 80))
                            .fadeIn(duration: 300.ms)
                            .slideX(begin: 0.05, end: 0),
                      );
                    },
                    childCount: Rank.values.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.beVietnamPro(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String emoji, String label, bool unlocked) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: unlocked ? AppColors.primarySurface : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: unlocked ? AppColors.primary.withValues(alpha: 0.3) : Colors.grey.shade200,
            ),
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 24,
                color: unlocked ? null : Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: unlocked ? AppColors.textPrimary : AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
