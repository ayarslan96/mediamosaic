import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediamosaic/presentation/theme/app_theme.dart';
import 'package:mediamosaic/presentation/widgets/bottom_nav_bar.dart';
import 'package:mediamosaic/presentation/screens/chat/chat_detail_screen.dart';
import 'package:mediamosaic/presentation/screens/chat/friend_search_screen.dart';
import 'package:mediamosaic/presentation/widgets/theme_toggle_button.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _chats = [];
  final List<Map<String, dynamic>> _onlineFriends = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadChats();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadChats() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      final mockChats = [
        {
          'id': '1',
          'username': 'alexjohnson',
          'displayName': 'Alex Johnson',
          'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
          'lastMessage': 'Did you see that new tech article?',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
          'unreadCount': 2,
          'isOnline': true,
        },
        {
          'id': '2',
          'username': 'sarahsmith',
          'displayName': 'Sarah Smith',
          'avatar': 'https://randomuser.me/api/portraits/women/17.jpg',
          'lastMessage': 'Thanks for sharing that meme 😂',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
          'unreadCount': 0,
          'isOnline': true,
        },
        {
          'id': '3',
          'username': 'mikebrown',
          'displayName': 'Mike Brown',
          'avatar': 'https://randomuser.me/api/portraits/men/45.jpg',
          'lastMessage': 'Check out this trending video',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
          'unreadCount': 1,
          'isOnline': false,
        },
        {
          'id': '4',
          'username': 'jennawilson',
          'displayName': 'Jenna Wilson',
          'avatar': 'https://randomuser.me/api/portraits/women/56.jpg',
          'lastMessage': 'What did you think about the news today?',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'unreadCount': 0,
          'isOnline': false,
        },
        {
          'id': '5',
          'username': 'davidmiller',
          'displayName': 'David Miller',
          'avatar': 'https://randomuser.me/api/portraits/men/22.jpg',
          'lastMessage': 'Let\'s catch up soon!',
          'timestamp': DateTime.now().subtract(const Duration(days: 2)),
          'unreadCount': 0,
          'isOnline': true,
        },
      ];
      
      final onlineFriends = mockChats.where((chat) => chat['isOnline'] == true).toList();
      
      setState(() {
        _chats.clear();
        _onlineFriends.clear();
        _chats.addAll(mockChats);
        _onlineFriends.addAll(onlineFriends);
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load chats: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _refreshChats() async {
    // Provide haptic feedback
    HapticFeedback.mediumImpact();
    
    setState(() {
      _isRefreshing = true;
    });
    
    await _loadChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          const ThemeToggleButton(mini: true),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendSearchScreen(),
                ),
              );
            },
            tooltip: 'Search Users',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Messages'),
            Tab(text: 'Online Friends'),
          ],
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: _isLoading && !_isRefreshing
          ? _buildSkeletonLoading()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildChatList(),
                _buildOnlineFriendsList(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FriendSearchScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        tooltip: 'New Message',
        child: const Icon(Icons.message),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }
  
  Widget _buildChatList() {
    if (_chats.isEmpty) {
      return _buildEmptyFriendsState();
    }
    
    return RefreshIndicator(
      onRefresh: _refreshChats,
      color: AppTheme.primaryColor,
      child: _isRefreshing
          ? _buildSkeletonListItems()
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                final isUnread = chat['unreadCount'] > 0;
                
                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(chat['avatar']),
                        radius: 24,
                      ),
                      if (chat['isOnline'])
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    chat['displayName'],
                    style: TextStyle(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    chat['lastMessage'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isUnread ? Colors.black87 : Colors.grey[600],
                      fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatTimestamp(chat['timestamp']),
                        style: TextStyle(
                          fontSize: 12,
                          color: isUnread ? AppTheme.primaryColor : Colors.grey[500],
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isUnread)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              chat['unreadCount'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    // Provide haptic feedback
                    HapticFeedback.selectionClick();
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          userId: chat['id'],
                          displayName: chat['displayName'],
                          avatar: chat['avatar'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
  
  Widget _buildEmptyFriendsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            const Text(
              'No friends yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add friends to start chatting and sharing your favorite media content',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Provide haptic feedback
                HapticFeedback.mediumImpact();
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FriendSearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Find Friends'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOnlineFriendsList() {
    if (_onlineFriends.isEmpty) {
      return _buildEmptyFriendsState();
    }
    
    return RefreshIndicator(
      onRefresh: _refreshChats,
      color: AppTheme.primaryColor,
      child: _isRefreshing
          ? _buildSkeletonListItems()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${_onlineFriends.length} friends online now',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _onlineFriends.length,
                    itemBuilder: (context, index) {
                      final friend = _onlineFriends[index];
                      
                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(friend['avatar']),
                              radius: 24,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(friend['displayName']),
                        subtitle: Text('@${friend['username']}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Provide haptic feedback
                            HapticFeedback.selectionClick();
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailScreen(
                                  userId: friend['id'],
                                  displayName: friend['displayName'],
                                  avatar: friend['avatar'],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text('Message'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildSkeletonLoading() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildSkeletonListItems(),
        _buildSkeletonListItems(),
      ],
    );
  }
  
  Widget _buildSkeletonListItems() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Avatar skeleton
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name skeleton
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Message skeleton
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Time skeleton
              Container(
                width: 30,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
} 