import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../models/photo_chain.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final chains = appState.communityChains;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverAppBar(
                expandedHeight: 160,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF00695C), Color(0xFF00897B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Khám Phá',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tham gia chuỗi cộng đồng và nhận XP!',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Trending Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.local_fire_department_rounded, color: AppColors.error, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Đang Trending',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                ),
              ),

              // Featured Chain
              if (chains.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildFeaturedChain(context, chains.first)
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
                ),

              // Hashtag Quick Access
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chủ Đề Nổi Bật',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: chains.map((c) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                              ),
                              child: Text(
                                c.hashtag ?? '#${c.theme}',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                      ),
                    ],
                  ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                ),
              ),

              // All Community Chains
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Text(
                    'Tất Cả Chuỗi',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= chains.length) return null;
                      final chain = chains[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCommunityChainCard(context, chain)
                            .animate(delay: Duration(milliseconds: 100 * index + 400))
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.05, end: 0),
                      );
                    },
                    childCount: chains.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeaturedChain(BuildContext context, PhotoChain chain) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 14, color: Colors.orange.shade300),
                    const SizedBox(width: 4),
                    Text(
                      'HOT',
                      style: GoogleFonts.beVietnamPro(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                chain.hashtag ?? '',
                style: GoogleFonts.beVietnamPro(fontSize: 13, color: Colors.white.withValues(alpha: 0.7)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(chain.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chain.theme,
                      style: GoogleFonts.beVietnamPro(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Text(
                      '${chain.photoCount} ảnh • ${chain.participantCount} người tham gia',
                      style: GoogleFonts.beVietnamPro(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Photo preview row
          SizedBox(
            height: 60,
            child: Row(
              children: [
                ...List.generate(5, (i) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15 + i * 0.03),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.image_rounded, color: Colors.white.withValues(alpha: 0.5), size: 24),
                  ),
                )),
                const Spacer(),
                Text('+${chain.photoCount - 5}', style: GoogleFonts.beVietnamPro(fontSize: 13, color: Colors.white.withValues(alpha: 0.7))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text('Tham Gia Ngay • +${chain.xpReward} XP', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityChainCard(BuildContext context, PhotoChain chain) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(chain.emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chain.theme,
                  style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.photo_rounded, size: 13, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Text(
                      '${chain.photoCount} ảnh',
                      style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.people_rounded, size: 13, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Text(
                      '${chain.participantCount}',
                      style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Join button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Join',
              style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
