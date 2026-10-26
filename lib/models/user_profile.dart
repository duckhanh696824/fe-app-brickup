import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum Rank {
  bronze(0, 'Bronze', '🥉', AppColors.rankBronze),
  silver(200, 'Silver', '🥈', AppColors.rankSilver),
  gold(500, 'Gold', '🥇', AppColors.rankGold),
  diamond(1000, 'Diamond', '💎', AppColors.rankDiamond),
  master(2500, 'Master', '👑', AppColors.rankMaster),
  legend(5000, 'Legend', '🌟', AppColors.rankLegend),
  mythic(10000, 'Mythic', '⚡', AppColors.rankMythic);

  final int requiredXP;
  final String label;
  final String emoji;
  final Color color;

  const Rank(this.requiredXP, this.label, this.emoji, this.color);
}

class UserProfile {
  final String name;
  final String avatarUrl;
  int totalXP;
  int currentStreak;
  int longestStreak;
  int totalPhotos;
  int questsCompleted;
  int chainsCompleted;
  List<String> badges;
  DateTime lastActiveDate;

  UserProfile({
    this.name = 'Brickup User',
    this.avatarUrl = '',
    this.totalXP = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalPhotos = 0,
    this.questsCompleted = 0,
    this.chainsCompleted = 0,
    this.badges = const [],
    DateTime? lastActiveDate,
  }) : lastActiveDate = lastActiveDate ?? DateTime.now();

  Rank get currentRank {
    Rank result = Rank.bronze;
    for (final rank in Rank.values) {
      if (totalXP >= rank.requiredXP) {
        result = rank;
      }
    }
    return result;
  }

  Rank? get nextRank {
    final ranks = Rank.values;
    final currentIndex = ranks.indexOf(currentRank);
    if (currentIndex < ranks.length - 1) {
      return ranks[currentIndex + 1];
    }
    return null;
  }

  double get rankProgress {
    final next = nextRank;
    if (next == null) return 1.0;
    final currentMin = currentRank.requiredXP;
    final nextMin = next.requiredXP;
    return ((totalXP - currentMin) / (nextMin - currentMin)).clamp(0.0, 1.0);
  }

  int get xpToNextRank {
    final next = nextRank;
    if (next == null) return 0;
    return next.requiredXP - totalXP;
  }
}
