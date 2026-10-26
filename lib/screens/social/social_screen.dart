import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../models/photo_chain.dart';
import '../../widgets/chain_card.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final chains = appState.friendChains;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
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
                              'Chuỗi Bạn Bè',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tạo chuỗi ảnh và nhận XP cùng bạn bè!',
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

              // Active Chains Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.link_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Chuỗi đang hoạt động',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${chains.length}',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                ),
              ),

              // Chain Cards
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final chain = chains[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ChainCard(
                          chain: chain,
                          onTap: () => _showChainDetail(context, chain),
                        ).animate(delay: Duration(milliseconds: 100 * index))
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1, end: 0, duration: 400.ms),
                      );
                    },
                    childCount: chains.length,
                  ),
                ),
              ),

              // Create new chain
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: InkWell(
                    onTap: () => _showCreateChainDialog(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 28),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tạo Chuỗi Mới',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mời bạn bè và bắt đầu chuỗi ảnh',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChainDetail(BuildContext context, PhotoChain chain) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChainDetailSheet(chain: chain),
    );
  }

  void _showCreateChainDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tạo Chuỗi Mới',
              style: GoogleFonts.beVietnamPro(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chọn chủ đề cho chuỗi ảnh của bạn',
              style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildThemeChip('🌿 Thiên Nhiên'),
                _buildThemeChip('🍜 Đồ Ăn'),
                _buildThemeChip('🌅 Hoàng Hôn'),
                _buildThemeChip('🏙️ Đường Phố'),
                _buildThemeChip('😊 Nụ Cười'),
                _buildThemeChip('🎨 Nghệ Thuật'),
                _buildThemeChip('☕ Cà Phê'),
                _buildThemeChip('🐾 Thú Cưng'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Mời Bạn Bè & Bắt Đầu', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
      ),
    );
  }
}

class _ChainDetailSheet extends StatelessWidget {
  final PhotoChain chain;
  const _ChainDetailSheet({required this.chain});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(chain.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chain.theme,
                          style: GoogleFonts.beVietnamPro(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${chain.photoCount} ảnh • ${chain.participantCount} người',
                          style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${chain.xpReward} XP',
                      style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Photo Grid
            Expanded(
              child: chain.photos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera_rounded, size: 64, color: AppColors.textLight.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Text('Chưa có ảnh nào', style: GoogleFonts.beVietnamPro(color: AppColors.textSecondary)),
                          const SizedBox(height: 8),
                          Text('Hãy là người đầu tiên!', style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textLight)),
                        ],
                      ),
                    )
                  : GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: chain.photos.length + 1,
                      itemBuilder: (context, index) {
                        if (index == chain.photos.length) {
                          // Add photo button
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 28),
                          );
                        }
                        final photo = chain.photos[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: [
                              AppColors.primary.withValues(alpha: 0.2),
                              AppColors.secondary.withValues(alpha: 0.2),
                              AppColors.primaryLight.withValues(alpha: 0.3),
                              AppColors.info.withValues(alpha: 0.2),
                            ][index % 4],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(Icons.image_rounded, color: AppColors.primary.withValues(alpha: 0.5), size: 32),
                              ),
                              Positioned(
                                bottom: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    photo.userName,
                                    style: GoogleFonts.beVietnamPro(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.favorite, size: 10, color: Colors.redAccent),
                                      const SizedBox(width: 2),
                                      Text('${photo.likes}', style: GoogleFonts.beVietnamPro(fontSize: 9, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
