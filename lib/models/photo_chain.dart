class PhotoChain {
  final String id;
  final String theme;
  final String emoji;
  final List<ChainPhoto> photos;
  final List<String> participants;
  final DateTime createdAt;
  final bool isCommunity;
  final String? hashtag;
  final int xpReward;

  PhotoChain({
    required this.id,
    required this.theme,
    required this.emoji,
    this.photos = const [],
    this.participants = const [],
    required this.createdAt,
    this.isCommunity = false,
    this.hashtag,
    this.xpReward = 20,
  });

  int get photoCount => photos.length;
  int get participantCount => participants.length;
}

class ChainPhoto {
  final String id;
  final String imageUrl;
  final String userId;
  final String userName;
  final DateTime takenAt;
  final int likes;

  ChainPhoto({
    required this.id,
    required this.imageUrl,
    required this.userId,
    required this.userName,
    required this.takenAt,
    this.likes = 0,
  });
}
