import 'dart:math';
import 'package:flutter/material.dart';
import '../models/quest.dart';
import '../theme/app_colors.dart';

class QuestService {
  static final List<Quest> _questPool = [
    Quest(
      id: 'color_red', title: 'Sắc Đỏ', description: 'Chụp 3 thứ có màu đỏ quanh bạn',
      icon: Icons.circle, color: Colors.red, xpReward: 25, target: 3,
      type: QuestType.random, difficulty: QuestDifficulty.medium,
    ),
    Quest(
      id: 'color_blue', title: 'Trời Xanh', description: 'Chụp 2 thứ có màu xanh dương',
      icon: Icons.circle, color: Colors.blue, xpReward: 20, target: 2,
      type: QuestType.random, difficulty: QuestDifficulty.easy,
    ),
    Quest(
      id: 'color_yellow', title: 'Nắng Vàng', description: 'Chụp 3 thứ có màu vàng',
      icon: Icons.circle, color: Colors.amber, xpReward: 25, target: 3,
      type: QuestType.random, difficulty: QuestDifficulty.medium,
    ),
    Quest(
      id: 'food', title: 'Thực Phẩm', description: 'Chụp bữa ăn hôm nay',
      icon: Icons.restaurant, color: Colors.orange, xpReward: 15, target: 1,
      type: QuestType.random, difficulty: QuestDifficulty.easy,
    ),
    Quest(
      id: 'nature', title: 'Thiên Nhiên', description: 'Chụp 2 bức ảnh về thiên nhiên',
      icon: Icons.eco, color: AppColors.primary, xpReward: 20, target: 2,
      type: QuestType.random, difficulty: QuestDifficulty.easy,
    ),
    Quest(
      id: 'street', title: 'Đường Phố', description: 'Chụp 2 cảnh đường phố',
      icon: Icons.location_city, color: Colors.blueGrey, xpReward: 20, target: 2,
      type: QuestType.random, difficulty: QuestDifficulty.easy,
    ),
    Quest(
      id: 'sky', title: 'Bầu Trời', description: 'Chụp ảnh bầu trời lúc này',
      icon: Icons.cloud, color: Colors.lightBlue, xpReward: 15, target: 1,
      type: QuestType.random, difficulty: QuestDifficulty.easy,
    ),
    Quest(
      id: 'smile', title: 'Nụ Cười', description: 'Chụp thứ gì khiến bạn mỉm cười',
      icon: Icons.mood, color: Colors.pink, xpReward: 15, target: 1,
      type: QuestType.random, difficulty: QuestDifficulty.easy,
    ),
    Quest(
      id: 'shadow', title: 'Bóng Đổ', description: 'Chụp 2 bức ảnh về bóng đổ',
      icon: Icons.contrast, color: Colors.grey.shade800, xpReward: 25, target: 2,
      type: QuestType.random, difficulty: QuestDifficulty.medium,
    ),
    Quest(
      id: 'circle', title: 'Hình Tròn', description: 'Tìm 3 thứ hình tròn quanh bạn',
      icon: Icons.panorama_fish_eye, color: Colors.deepPurple, xpReward: 30, target: 3,
      type: QuestType.random, difficulty: QuestDifficulty.hard,
    ),
    Quest(
      id: 'pet', title: 'Thú Cưng', description: 'Chụp ảnh thú cưng hoặc động vật',
      icon: Icons.pets, color: Colors.brown, xpReward: 15, target: 1,
      type: QuestType.random, difficulty: QuestDifficulty.easy,
    ),
    Quest(
      id: 'morning', title: 'Buổi Sáng', description: 'Chụp khoảnh khắc buổi sáng',
      icon: Icons.wb_sunny, color: Colors.amber.shade700, xpReward: 15, target: 1,
      type: QuestType.random, difficulty: QuestDifficulty.easy,
    ),
    Quest(
      id: 'reflection', title: 'Phản Chiếu', description: 'Chụp ảnh có sự phản chiếu',
      icon: Icons.flip, color: Colors.teal, xpReward: 30, target: 1,
      type: QuestType.random, difficulty: QuestDifficulty.hard,
    ),
    Quest(
      id: 'texture', title: 'Kết Cấu', description: 'Chụp 2 bề mặt thú vị',
      icon: Icons.texture, color: Colors.brown.shade400, xpReward: 25, target: 2,
      type: QuestType.random, difficulty: QuestDifficulty.medium,
    ),
  ];

  static Quest getFixedQuest() {
    return Quest(
      id: 'daily_photo',
      title: 'Khoảnh Khắc Hôm Nay',
      description: 'Chụp ít nhất 1 bức ảnh trong ngày',
      icon: Icons.camera_alt,
      color: AppColors.primary,
      xpReward: 10,
      target: 1,
      type: QuestType.fixed,
      difficulty: QuestDifficulty.easy,
    );
  }

  static List<Quest> getDailyQuests(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);

    final shuffled = List<Quest>.from(_questPool)..shuffle(random);
    final randomQuests = shuffled.take(3).toList();

    return [getFixedQuest(), ...randomQuests];
  }

  static int calculateDailyXP(List<Quest> quests) {
    int xp = 0;
    int completedCount = 0;

    for (final quest in quests) {
      if (quest.isCompleted) {
        xp += quest.xpReward;
        completedCount++;
      }
    }

    // Bonus for completing all quests
    if (completedCount == quests.length) {
      xp += 30;
    }

    return xp;
  }

  static const int penaltyXP = 15;
  static const int allQuestBonus = 30;
  static const int streakBonus7Days = 50;
  static const int streakBonus30Days = 200;
}
