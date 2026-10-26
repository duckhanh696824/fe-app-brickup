import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../models/feed_post.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({super.key});

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              // ===== HEADER =====
              Container(
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
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Brickup',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('🧱', style: TextStyle(fontSize: 20)),
                            const Spacer(),
                            _buildHeaderButton(Icons.camera_alt_rounded),
                            const SizedBox(width: 10),
                            _buildHeaderButton(Icons.notifications_none_rounded),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ),

              // ===== TAB BAR =====
              Container(
                color: AppColors.surface,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'Bạn Bè'),
                    Tab(text: 'Cộng Đồng'),
                  ],
                ),
              ),

              // ===== TAB CONTENT =====
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFriendsFeed(appState),
                    _buildCommunityFeed(appState),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  // ==================== FRIENDS FEED TAB ====================
  Widget _buildFriendsFeed(AppState appState) {
    final posts = appState.friendFeedPosts;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
      itemCount: posts.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildFriendStoriesBar(appState.friends)
              .animate().fadeIn(duration: 400.ms);
        }
        final post = posts[index - 1];
        return _buildFriendPostCard(context, appState, post)
            .animate(delay: Duration(milliseconds: 80 * index))
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.04, end: 0, duration: 350.ms);
      },
    );
  }

  // ===== FRIEND STORIES BAR =====
  Widget _buildFriendStoriesBar(List<Friend> friends) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.textLight.withValues(alpha: 0.12)),
        ),
      ),
      child: SizedBox(
        height: 88,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: friends.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                      ),
                      child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 26),
                    ),
                    const SizedBox(height: 6),
                    Text('Đăng ảnh',
                      style: GoogleFonts.beVietnamPro(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }
            final friend = friends[index - 1];
            return Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A), Color(0xFF00E676)],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: CircleAvatar(
                            backgroundColor: AppColors.surface,
                            child: Text(
                              friend.name.split(' ').last[0],
                              style: GoogleFonts.beVietnamPro(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                      if (friend.isOnline)
                        Positioned(
                          bottom: 2, right: 2,
                          child: Container(
                            width: 14, height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.success, shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surface, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 62,
                    child: Text(
                      friend.name.split(' ').last,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.beVietnamPro(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ===== FRIEND POST CARD (Unique design — no comment, horizontal chain badge) =====
  Widget _buildFriendPostCard(BuildContext context, AppState appState, FeedPost post) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Top: User info + Chain badge ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                // Avatar with gradient ring
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundColor: AppColors.surface,
                      child: Text(
                        post.userName.split(' ').last[0],
                        style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      Text(
                        post.timeAgo,
                        style: GoogleFonts.beVietnamPro(fontSize: 11, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ),
                // Chain badge
                if (post.chainEmoji != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(post.chainEmoji!, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          post.chainTheme ?? '',
                          style: GoogleFonts.beVietnamPro(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // --- Image area (unique stacked look) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  color: _getPostColor(post.id),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -20, right: -20,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30, left: -30,
                      child: Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(post.chainEmoji ?? '📷', style: const TextStyle(fontSize: 52)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              post.chainTheme ?? 'Ảnh',
                              style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Caption ---
          if (post.caption != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                post.caption!,
                style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
              ),
            ),

          // --- Bottom action bar: Like + Share (no comment in friend feed) ---
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                // Like
                _buildActionChip(
                  icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  label: '${post.likes}',
                  color: post.isLiked ? AppColors.error : AppColors.textSecondary,
                  onTap: () => appState.toggleLikePost(post.id),
                ),
                const SizedBox(width: 8),
                // Share to community
                _buildActionChip(
                  icon: post.visibility == PostVisibility.both ? Icons.public_rounded : Icons.share_outlined,
                  label: post.visibility == PostVisibility.both ? 'Đã chia sẻ' : 'Chia sẻ',
                  color: post.visibility == PostVisibility.both ? AppColors.info : AppColors.textSecondary,
                  onTap: () => _showShareDialog(context, appState, post),
                ),
                const Spacer(),
                // Visibility badge
                if (post.visibility == PostVisibility.both)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.public_rounded, size: 12, color: AppColors.info),
                        const SizedBox(width: 3),
                        Text('Công khai', style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.info)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== COMMUNITY FEED TAB ====================
  Widget _buildCommunityFeed(AppState appState) {
    final posts = appState.communityFeedPosts;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
      itemCount: posts.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildTrendingBar().animate().fadeIn(duration: 400.ms);
        }
        final post = posts[index - 1];
        return _buildCommunityPostCard(context, appState, post)
            .animate(delay: Duration(milliseconds: 80 * index))
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.04, end: 0, duration: 350.ms);
      },
    );
  }

  Widget _buildTrendingBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 0, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.textLight.withValues(alpha: 0.12))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department_rounded, color: AppColors.error, size: 18),
              const SizedBox(width: 6),
              Text('Trending', style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildHashtagChip('#RedChallenge', '🔴'),
                _buildHashtagChip('#NatureVibes', '🌿'),
                _buildHashtagChip('#MorningCoffee', '☕'),
                _buildHashtagChip('#StreetLife', '🏙️'),
                _buildHashtagChip('#SmileChain', '😊'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== COMMUNITY POST CARD (has comments) =====
  Widget _buildCommunityPostCard(BuildContext context, AppState appState, FeedPost post) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Color(0xFF00695C), Color(0xFF00897B)]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundColor: AppColors.surface,
                      child: Text(
                        post.userName.split(' ').last[0],
                        style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.secondary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(post.userName,
                              style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('Cộng đồng',
                              style: GoogleFonts.beVietnamPro(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.secondary),
                            ),
                          ),
                        ],
                      ),
                      Text(post.timeAgo, style: GoogleFonts.beVietnamPro(fontSize: 11, color: AppColors.textLight)),
                    ],
                  ),
                ),
                if (post.chainEmoji != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(post.chainEmoji!, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(post.chainTheme ?? '', style: GoogleFonts.beVietnamPro(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(color: _getPostColor(post.id)),
                child: Stack(
                  children: [
                    Positioned(top: -20, right: -20, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06)))),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(post.chainEmoji ?? '📷', style: const TextStyle(fontSize: 52)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                            child: Text(post.chainTheme ?? 'Ảnh', style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Caption
          if (post.caption != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(post.caption!, style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
            ),

          // Action bar with Like + Comment (community has comments!)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              children: [
                _buildActionChip(
                  icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  label: '${post.likes}',
                  color: post.isLiked ? AppColors.error : AppColors.textSecondary,
                  onTap: () => appState.toggleLikePost(post.id),
                ),
                const SizedBox(width: 8),
                _buildActionChip(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${post.comments}',
                  color: AppColors.textSecondary,
                  onTap: () => _showCommentsSheet(context, post),
                ),
                const Spacer(),
                Icon(Icons.bookmark_border_rounded, color: AppColors.textLight, size: 22),
              ],
            ),
          ),

          // Comment preview (only in community)
          if (post.postComments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
              child: GestureDetector(
                onTap: () => _showCommentsSheet(context, post),
                child: Text(
                  'Xem ${post.comments} bình luận',
                  style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ),

          if (post.postComments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(text: '${post.postComments.first.userName} ', style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  TextSpan(text: post.postComments.first.content, style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textPrimary)),
                ]),
              ),
            ),

          if (post.postComments.isEmpty)
            const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ===== SHARED WIDGETS =====
  Widget _buildActionChip({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 5),
            Text(label, style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildHashtagChip(String tag, String emoji) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(tag, style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary)),
          ],
        ),
      ),
    );
  }

  Color _getPostColor(String id) {
    final colors = [
      const Color(0xFF1B5E20).withValues(alpha: 0.18),
      const Color(0xFF00695C).withValues(alpha: 0.18),
      const Color(0xFF0D47A1).withValues(alpha: 0.14),
      const Color(0xFFBF360C).withValues(alpha: 0.14),
      const Color(0xFF4A148C).withValues(alpha: 0.14),
      const Color(0xFFF57F17).withValues(alpha: 0.14),
      const Color(0xFF880E4F).withValues(alpha: 0.14),
      const Color(0xFF006064).withValues(alpha: 0.18),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }

  // ===== SHARE DIALOG =====
  void _showShareDialog(BuildContext context, AppState appState, FeedPost post) {
    if (post.visibility == PostVisibility.both || post.visibility == PostVisibility.community) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bài viết đã được chia sẻ lên cộng đồng!', style: GoogleFonts.beVietnamPro(fontSize: 13)),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textLight.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
              child: const Icon(Icons.public_rounded, color: AppColors.primary, size: 32),
            ),
            const SizedBox(height: 16),
            Text('Chia sẻ lên Cộng Đồng?', style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(
              'Bài viết sẽ hiển thị cho tất cả mọi người trong cộng đồng Brickup',
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: AppColors.textLight.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Hủy', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      appState.sharePostToCommunity(post.id);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text('Đã chia sẻ lên cộng đồng!', style: GoogleFonts.beVietnamPro(fontSize: 13)),
                          ]),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Chia sẻ', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ===== COMMENTS SHEET (only for community) =====
  void _showCommentsSheet(BuildContext context, FeedPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textLight.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Bình luận', style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ),
              const Divider(height: 1),
              Expanded(
                child: post.postComments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.textLight.withValues(alpha: 0.3)),
                            const SizedBox(height: 12),
                            Text('Chưa có bình luận nào', style: GoogleFonts.beVietnamPro(color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Text('Hãy là người đầu tiên bình luận!', style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textLight)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: post.postComments.length,
                        itemBuilder: (context, index) {
                          final comment = post.postComments[index];
                          final diff = DateTime.now().difference(comment.createdAt);
                          final timeStr = diff.inMinutes < 60 ? '${diff.inMinutes}p' : diff.inHours < 24 ? '${diff.inHours}h' : '${diff.inDays}d';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.primarySurface,
                                  child: Text(comment.userName.split(' ').last[0], style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(text: TextSpan(children: [
                                        TextSpan(text: '${comment.userName} ', style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                        TextSpan(text: comment.content, style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textPrimary)),
                                      ])),
                                      const SizedBox(height: 4),
                                      Text(timeStr, style: GoogleFonts.beVietnamPro(fontSize: 11, color: AppColors.textLight)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              // Comment input
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.textLight.withValues(alpha: 0.15))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(24)),
                        child: Text('Viết bình luận...', style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textLight)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
