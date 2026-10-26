import '../models/user_profile.dart';

class RankService {
  static String getRankDescription(Rank rank) {
    switch (rank) {
      case Rank.bronze:
        return 'Người mới bắt đầu • 2 quest/ngày';
      case Rank.silver:
        return 'Đang tiến bộ • 3 quest/ngày';
      case Rank.gold:
        return 'Nhiếp ảnh gia • 4 quest/ngày';
      case Rank.diamond:
        return 'Chuyên gia • Tạo quest cộng đồng';
      case Rank.master:
        return 'Bậc thầy • Custom frame';
      case Rank.legend:
        return 'Huyền thoại • Tạo challenge riêng';
      case Rank.mythic:
        return 'Thần thoại • Avatar viền lửa';
    }
  }

  static int getMaxQuestsForRank(Rank rank) {
    switch (rank) {
      case Rank.bronze:
        return 3;
      case Rank.silver:
        return 4;
      case Rank.gold:
      case Rank.diamond:
      case Rank.master:
      case Rank.legend:
      case Rank.mythic:
        return 5;
    }
  }

  static bool checkRankUp(int oldXP, int newXP) {
    Rank oldRank = Rank.bronze;
    Rank newRank = Rank.bronze;

    for (final rank in Rank.values) {
      if (oldXP >= rank.requiredXP) oldRank = rank;
      if (newXP >= rank.requiredXP) newRank = rank;
    }

    return newRank.index > oldRank.index;
  }
}
