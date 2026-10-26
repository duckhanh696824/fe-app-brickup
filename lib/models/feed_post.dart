enum PostVisibility { friends, community, both }

class FeedPost {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String? imageUrl;
  final String? caption;
  final String? chainTheme;
  final String? chainEmoji;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isLiked;
  final PostVisibility visibility;
  final List<PostComment> postComments;

  FeedPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    this.imageUrl,
    this.caption,
    this.chainTheme,
    this.chainEmoji,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.visibility = PostVisibility.friends,
    this.postComments = const [],
  });

  FeedPost copyWith({
    int? likes,
    int? comments,
    bool? isLiked,
    PostVisibility? visibility,
    List<PostComment>? postComments,
  }) {
    return FeedPost(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      imageUrl: imageUrl,
      caption: caption,
      chainTheme: chainTheme,
      chainEmoji: chainEmoji,
      createdAt: createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      visibility: visibility ?? this.visibility,
      postComments: postComments ?? this.postComments,
    );
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${(diff.inDays / 7).floor()} tuần trước';
  }
}

class PostComment {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  PostComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });
}

class Friend {
  final String id;
  final String name;
  final String avatarUrl;
  final int totalPhotos;
  final bool isOnline;

  Friend({
    required this.id,
    required this.name,
    this.avatarUrl = '',
    this.totalPhotos = 0,
    this.isOnline = false,
  });
}
