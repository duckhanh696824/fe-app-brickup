import 'package:flutter/material.dart';

enum QuestType { fixed, random }
enum QuestDifficulty { easy, medium, hard }

class Quest {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int xpReward;
  final int target;
  int progress;
  final QuestType type;
  final QuestDifficulty difficulty;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.xpReward,
    required this.target,
    this.progress = 0,
    required this.type,
    required this.difficulty,
  });

  bool get isCompleted => progress >= target;
  double get progressPercent => (progress / target).clamp(0.0, 1.0);

  Quest copyWith({int? progress}) {
    return Quest(
      id: id,
      title: title,
      description: description,
      icon: icon,
      color: color,
      xpReward: xpReward,
      target: target,
      progress: progress ?? this.progress,
      type: type,
      difficulty: difficulty,
    );
  }
}
