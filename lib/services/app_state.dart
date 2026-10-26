import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/quest.dart';
import '../models/photo_chain.dart';
import '../models/feed_post.dart';
import '../services/quest_service.dart';

class AppState extends ChangeNotifier {
  final UserProfile _profile = UserProfile();
  List<Quest> _dailyQuests = [];
  List<PhotoChain> _friendChains = [];
  List<PhotoChain> _communityChains = [];
  List<Friend> _friends = [];
  List<FeedPost> _feedPosts = [];

  UserProfile get profile => _profile;
  List<Quest> get dailyQuests => _dailyQuests;
  List<PhotoChain> get friendChains => _friendChains;
  List<PhotoChain> get communityChains => _communityChains;
  List<Friend> get friends => _friends;
  List<FeedPost> get feedPosts => _feedPosts;

  List<FeedPost> get friendFeedPosts =>
      _feedPosts.where((p) => p.visibility == PostVisibility.friends || p.visibility == PostVisibility.both).toList();

  List<FeedPost> get communityFeedPosts =>
      _feedPosts.where((p) => p.visibility == PostVisibility.community || p.visibility == PostVisibility.both).toList();

  AppState() {
    _initializeData();
  }

  void _initializeData() {
    _loadDailyQuests();
    _loadSampleFriends();
    _loadSampleFeed();
    _loadSampleChains();
  }

  void _loadDailyQuests() {
    final today = DateTime.now();
    _dailyQuests = QuestService.getDailyQuests(today);
  }

  void toggleLikePost(String postId) {
    final index = _feedPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _feedPosts[index];
      _feedPosts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
      notifyListeners();
    }
  }

  void sharePostToCommunity(String postId) {
    final index = _feedPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _feedPosts[index];
      if (post.visibility == PostVisibility.friends) {
        _feedPosts[index] = post.copyWith(visibility: PostVisibility.both);
        notifyListeners();
      }
    }
  }

  void completeQuestProgress(String questId, {int amount = 1}) {
    final index = _dailyQuests.indexWhere((q) => q.id == questId);
    if (index != -1) {
      final quest = _dailyQuests[index];
      if (!quest.isCompleted) {
        final newProgress = (quest.progress + amount).clamp(0, quest.target);
        _dailyQuests[index] = quest.copyWith(progress: newProgress);

        if (_dailyQuests[index].isCompleted) {
          _profile.totalXP += quest.xpReward;
          _profile.questsCompleted++;
          _profile.totalPhotos += amount;

          // Check all quests completed bonus
          if (_dailyQuests.every((q) => q.isCompleted)) {
            _profile.totalXP += QuestService.allQuestBonus;
          }
        }
        notifyListeners();
      }
    }
  }

  void addXPFromChain(int xp) {
    _profile.totalXP += xp;
    _profile.chainsCompleted++;
    notifyListeners();
  }

  void _loadSampleFriends() {
    _friends = [
      Friend(id: 'f1', name: 'Minh Trần', totalPhotos: 42, isOnline: true),
      Friend(id: 'f2', name: 'Lan Nguyễn', totalPhotos: 38, isOnline: true),
      Friend(id: 'f3', name: 'Hùng Phạm', totalPhotos: 25, isOnline: false),
      Friend(id: 'f4', name: 'An Lê', totalPhotos: 56, isOnline: true),
      Friend(id: 'f5', name: 'Trang Vũ', totalPhotos: 31, isOnline: false),
      Friend(id: 'f6', name: 'Tuấn Đặng', totalPhotos: 19, isOnline: false),
      Friend(id: 'f7', name: 'Mai Hoàng', totalPhotos: 47, isOnline: true),
    ];
  }

  void _loadSampleFeed() {
    _feedPosts = [
      FeedPost(
        id: 'fp1',
        userId: 'f1',
        userName: 'Minh Trần',
        caption: 'Buổi sáng đẹp trời quá! ☀️ Đi chụp ảnh thiên nhiên nào~',
        chainTheme: 'Thiên Nhiên',
        chainEmoji: '🌿',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        likes: 12,
        comments: 3,
        visibility: PostVisibility.friends,
        postComments: [
          PostComment(id: 'c1', userId: 'f2', userName: 'Lan Nguyễn', content: 'Đẹp quá! 😍', createdAt: DateTime.now().subtract(const Duration(minutes: 10))),
          PostComment(id: 'c2', userId: 'f4', userName: 'An Lê', content: 'Chụp ở đâu vậy?', createdAt: DateTime.now().subtract(const Duration(minutes: 5))),
        ],
      ),
      FeedPost(
        id: 'fp2',
        userId: 'f2',
        userName: 'Lan Nguyễn',
        caption: 'Cà phê sáng thứ 2 ☕ Bắt đầu tuần mới nào!',
        chainTheme: 'Cà Phê Sáng',
        chainEmoji: '☕',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likes: 8,
        comments: 2,
        visibility: PostVisibility.friends,
        postComments: [
          PostComment(id: 'c3', userId: 'f1', userName: 'Minh Trần', content: 'Quán nào ngon vậy?', createdAt: DateTime.now().subtract(const Duration(minutes: 45))),
        ],
      ),
      FeedPost(
        id: 'fp3',
        userId: 'f4',
        userName: 'An Lê',
        caption: 'Hoàng hôn hôm nay rực rỡ quá 🌅 Share cho mọi người cùng ngắm!',
        chainTheme: 'Hoàng Hôn',
        chainEmoji: '🌅',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likes: 24,
        comments: 7,
        visibility: PostVisibility.both,
        postComments: [
          PostComment(id: 'c4', userId: 'f7', userName: 'Mai Hoàng', content: 'Tuyệt vời! 🔥', createdAt: DateTime.now().subtract(const Duration(hours: 2))),
        ],
      ),
      FeedPost(
        id: 'fp4',
        userId: 'f7',
        userName: 'Mai Hoàng',
        caption: 'Màu đỏ ở khắp nơi~ 🔴 Tham gia #RedChallenge nè!',
        chainTheme: 'Sắc Đỏ',
        chainEmoji: '🔴',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 31,
        comments: 9,
        visibility: PostVisibility.community,
      ),
      FeedPost(
        id: 'fp5',
        userId: 'f3',
        userName: 'Hùng Phạm',
        caption: 'Chụp lén bạn bè 😄 Ai nhận ra đây!',
        chainTheme: 'Nụ Cười',
        chainEmoji: '😊',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        likes: 15,
        comments: 5,
        visibility: PostVisibility.friends,
      ),
      FeedPost(
        id: 'fp6',
        userId: 'f5',
        userName: 'Trang Vũ',
        caption: 'Đường phố Sài Gòn về đêm 🏙️ Cứ mỗi góc phố lại một câu chuyện',
        chainTheme: 'Đường Phố',
        chainEmoji: '🏙️',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        likes: 19,
        comments: 4,
        visibility: PostVisibility.both,
      ),
      FeedPost(
        id: 'fp7',
        userId: 'f6',
        userName: 'Tuấn Đặng',
        caption: 'Thú cưng nhà mình nè 🐾 Cute quá đi!',
        chainTheme: 'Thú Cưng',
        chainEmoji: '🐾',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 28,
        comments: 11,
        visibility: PostVisibility.friends,
      ),
      FeedPost(
        id: 'fp8',
        userId: 'f1',
        userName: 'Minh Trần',
        caption: 'Đồ ăn đường phố Việt Nam 🍜 Ngon khỏi bàn!',
        chainTheme: 'Đồ Ăn Ngon',
        chainEmoji: '🍜',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        likes: 22,
        comments: 6,
        visibility: PostVisibility.both,
      ),
    ];
  }

  void _loadSampleChains() {
    _friendChains = [
      PhotoChain(
        id: 'fc1',
        theme: 'Màu Xanh Lá',
        emoji: '🌿',
        participants: ['Minh', 'Lan', 'Hùng'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        photos: [
          ChainPhoto(id: 'p1', imageUrl: '', userId: 'u1', userName: 'Minh', takenAt: DateTime.now().subtract(const Duration(days: 2)), likes: 5),
          ChainPhoto(id: 'p2', imageUrl: '', userId: 'u2', userName: 'Lan', takenAt: DateTime.now().subtract(const Duration(days: 1)), likes: 3),
        ],
        xpReward: 20,
      ),
      PhotoChain(
        id: 'fc2',
        theme: 'Đồ Ăn Ngon',
        emoji: '🍜',
        participants: ['Bạn', 'Trang'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        photos: [
          ChainPhoto(id: 'p3', imageUrl: '', userId: 'u1', userName: 'Bạn', takenAt: DateTime.now().subtract(const Duration(hours: 12)), likes: 2),
        ],
        xpReward: 20,
      ),
      PhotoChain(
        id: 'fc3',
        theme: 'Hoàng Hôn',
        emoji: '🌅',
        participants: ['Bạn', 'Minh', 'An', 'Tuấn'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        photos: [
          ChainPhoto(id: 'p4', imageUrl: '', userId: 'u1', userName: 'Bạn', takenAt: DateTime.now().subtract(const Duration(days: 5)), likes: 8),
          ChainPhoto(id: 'p5', imageUrl: '', userId: 'u3', userName: 'An', takenAt: DateTime.now().subtract(const Duration(days: 4)), likes: 6),
          ChainPhoto(id: 'p6', imageUrl: '', userId: 'u4', userName: 'Tuấn', takenAt: DateTime.now().subtract(const Duration(days: 3)), likes: 4),
        ],
        xpReward: 20,
      ),
    ];

    _communityChains = [
      PhotoChain(
        id: 'cc1',
        theme: 'Sắc Đỏ',
        emoji: '🔴',
        participants: List.generate(124, (i) => 'User $i'),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isCommunity: true,
        hashtag: '#RedChallenge',
        photos: List.generate(47, (i) => ChainPhoto(
          id: 'cp$i', imageUrl: '', userId: 'cu$i', userName: 'User $i',
          takenAt: DateTime.now().subtract(Duration(hours: i * 2)), likes: (47 - i) * 2,
        )),
        xpReward: 15,
      ),
      PhotoChain(
        id: 'cc2',
        theme: 'Thiên Nhiên',
        emoji: '🌿',
        participants: List.generate(89, (i) => 'User $i'),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isCommunity: true,
        hashtag: '#NatureVibes',
        photos: List.generate(32, (i) => ChainPhoto(
          id: 'np$i', imageUrl: '', userId: 'nu$i', userName: 'User $i',
          takenAt: DateTime.now().subtract(Duration(hours: i * 3)), likes: (32 - i) * 3,
        )),
        xpReward: 15,
      ),
      PhotoChain(
        id: 'cc3',
        theme: 'Cà Phê Sáng',
        emoji: '☕',
        participants: List.generate(56, (i) => 'User $i'),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isCommunity: true,
        hashtag: '#MorningCoffee',
        photos: List.generate(21, (i) => ChainPhoto(
          id: 'mp$i', imageUrl: '', userId: 'mu$i', userName: 'User $i',
          takenAt: DateTime.now().subtract(Duration(hours: i)), likes: (21 - i) * 2,
        )),
        xpReward: 15,
      ),
      PhotoChain(
        id: 'cc4',
        theme: 'Đường Phố',
        emoji: '🏙️',
        participants: List.generate(201, (i) => 'User $i'),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        isCommunity: true,
        hashtag: '#StreetLife',
        photos: List.generate(78, (i) => ChainPhoto(
          id: 'sp$i', imageUrl: '', userId: 'su$i', userName: 'User $i',
          takenAt: DateTime.now().subtract(Duration(hours: i)), likes: (78 - i),
        )),
        xpReward: 15,
      ),
      PhotoChain(
        id: 'cc5',
        theme: 'Nụ Cười',
        emoji: '😊',
        participants: List.generate(143, (i) => 'User $i'),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isCommunity: true,
        hashtag: '#SmileChain',
        photos: List.generate(55, (i) => ChainPhoto(
          id: 'smile$i', imageUrl: '', userId: 'smu$i', userName: 'User $i',
          takenAt: DateTime.now().subtract(Duration(hours: i * 2)), likes: (55 - i) * 2,
        )),
        xpReward: 15,
      ),
    ];
  }
}
