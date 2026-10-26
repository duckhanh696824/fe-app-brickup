import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/user_profile.dart';

class XpHeader extends StatelessWidget {
  final UserProfile profile;

  const XpHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${profile.totalXP} XP',
              style: GoogleFonts.beVietnamPro(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            if (profile.nextRank != null)
              Text(
                '${profile.nextRank!.emoji} ${profile.nextRank!.label} (${profile.xpToNextRank} XP)',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          lineHeight: 10,
          percent: profile.rankProgress,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          progressColor: Colors.white,
          barRadius: const Radius.circular(5),
          padding: EdgeInsets.zero,
          animation: true,
          animationDuration: 800,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.local_fire_department_rounded, size: 14, color: Colors.orange.shade300),
            const SizedBox(width: 4),
            Text(
              'Streak: ${profile.currentStreak} ngày',
              style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(width: 16),
            Icon(Icons.photo_camera_rounded, size: 14, color: Colors.white.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Text(
              '${profile.totalPhotos} ảnh',
              style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
