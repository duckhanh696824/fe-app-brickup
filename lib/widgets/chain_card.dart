import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/photo_chain.dart';

class ChainCard extends StatelessWidget {
  final PhotoChain chain;
  final VoidCallback onTap;

  const ChainCard({
    super.key,
    required this.chain,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji Avatar
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
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Photo count
                      Icon(Icons.photo_rounded, size: 13, color: AppColors.textLight),
                      const SizedBox(width: 3),
                      Text(
                        '${chain.photoCount} ảnh',
                        style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 12),
                      // Participants
                      Icon(Icons.people_rounded, size: 13, color: AppColors.textLight),
                      const SizedBox(width: 3),
                      Text(
                        chain.participants.take(2).join(', '),
                        style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (chain.participantCount > 2)
                        Text(
                          ' +${chain.participantCount - 2}',
                          style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // XP Badge + Arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '+${chain.xpReward} XP',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
