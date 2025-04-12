import 'package:flutter/material.dart';
import 'package:mediamosaic/presentation/theme/app_theme.dart';
import 'package:mediamosaic/presentation/screens/chat/chat_detail_screen.dart';

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _friendRequests = [];
  List<Map<String, dynamic>> _suggestedFriends = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final mockFriendRequests = [
        {
          'id': 'req1',
          'username': 'johndoe',
          'displayName': 'John Doe',
          'avatar': 'https://randomuser.me/api/portraits/men/75.jpg',
          'mutualFriends': 3,
          'bio': 'Film enthusiast and amateur photographer',
        },
        {
          'id': 'req2',
          'username': 'emilywilson',
          'displayName': 'Emily Wilson',
          'avatar': 'https://randomuser.me/api/portraits/women/63.jpg',
          'mutualFriends': 5,
          'bio': 'Music lover and concert-goer',
        },
      ];

      final mockSuggestedFriends = [
        {
          'id': 'sug1',
          'username': 'robertjones',
          'displayName': 'Robert Jones',
          'avatar': 'https://randomuser.me/api/portraits/men/41.jpg',
          'mutualFriends': 8,
          'bio': 'Documentary filmmaker and travel enthusiast',
          'commonInterests': ['Documentaries', 'History'],
        },
        {
          'id': 'sug2',
          'username': 'sarahmiller',
          'displayName': 'Sarah Miller',
          'avatar': 'https://randomuser.me/api/portraits/women/26.jpg',
          'mutualFriends': 2,
          'bio': 'Book lover and TV show binger',
          'commonInterests': ['Drama', 'Sci-Fi'],
        },
        {
          'id': 'sug3',
          'username': 'michaelbrown',
          'displayName': 'Michael Brown',
          'avatar': 'https://randomuser.me/api/portraits/men/55.jpg',
          'mutualFriends': 6,
          'bio': 'Podcast enthusiast and news junkie',
          'commonInterests': ['News', 'True Crime'],
        },
        {
          'id': 'sug4',
          'username': 'jenniferdavis',
          'displayName': 'Jennifer Davis',
          'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
          'mutualFriends': 4,
          'bio': 'Movie critic and anime fan',
          'commonInterests': ['Anime', 'Action'],
        },
      ];

      setState(() {
        _friendRequests = mockFriendRequests;
        _suggestedFriends = mockSuggestedFriends;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _searchQuery = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _searchQuery = query;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock search results
      final mockSearchResults = [
        {
          'id': 'user1',
          'username': 'davidwilson',
          'displayName': 'David Wilson',
          'avatar': 'https://randomuser.me/api/portraits/men/62.jpg',
          'mutualFriends': 0,
          'bio': 'Sports fan and comedy lover',
          'isFollowing': false,
        },
        {
          'id': 'user2',
          'username': 'amandaharris',
          'displayName': 'Amanda Harris',
          'avatar': 'https://randomuser.me/api/portraits/women/33.jpg',
          'mutualFriends': 1,
          'bio': 'Art enthusiast and photographer',
          'isFollowing': true,
        },
        {
          'id': 'user3',
          'username': 'richardbaker',
          'displayName': 'Richard Baker',
          'avatar': 'https://randomuser.me/api/portraits/men/29.jpg',
          'mutualFriends': 3,
          'bio': 'Music producer and vinyl collector',
          'isFollowing': false,
        },
      ].where((user) {
        return user['displayName'].toString().toLowerCase().contains(query.toLowerCase()) ||
            user['username'].toString().toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        _searchResults = mockSearchResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleFriendRequest(String userId, bool accept) {
    setState(() {
      _friendRequests.removeWhere((request) => request['id'] == userId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          accept
              ? 'Friend request accepted!'
              : 'Friend request declined',
        ),
        backgroundColor: accept ? Colors.green : Colors.grey,
      ),
    );
  }

  void _toggleFollowUser(String userId) {
    setState(() {
      for (var i = 0; i < _searchResults.length; i++) {
        if (_searchResults[i]['id'] == userId) {
          _searchResults[i]['isFollowing'] = !_searchResults[i]['isFollowing'];
          break;
        }
      }

      for (var i = 0; i < _suggestedFriends.length; i++) {
        if (_suggestedFriends[i]['id'] == userId) {
          _suggestedFriends[i]['isFollowing'] = 
              !(_suggestedFriends[i]['isFollowing'] ?? false);
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Friends'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Search'),
            Tab(text: 'Requests'),
            Tab(text: 'Suggested'),
          ],
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSearchTab(),
          _buildRequestsTab(),
          _buildSuggestedTab(),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for users by name or username',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onChanged: _performSearch,
            textInputAction: TextInputAction.search,
            onSubmitted: _performSearch,
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _searchQuery.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Search for users',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _searchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_off,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No users found for "$_searchQuery"',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final user = _searchResults[index];
                            return _buildUserListItem(
                              user,
                              showFollowButton: true,
                            );
                          },
                        ),
        ),
      ],
    );
  }

  Widget _buildRequestsTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _friendRequests.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No pending friend requests',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _friendRequests.length,
                itemBuilder: (context, index) {
                  final request = _friendRequests[index];
                  return _buildFriendRequestItem(request);
                },
              );
  }

  Widget _buildSuggestedTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _suggestedFriends.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_add,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No friend suggestions at the moment',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _suggestedFriends.length,
                itemBuilder: (context, index) {
                  final friend = _suggestedFriends[index];
                  return _buildSuggestedFriendItem(friend);
                },
              );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> user, {
    bool showFollowButton = false,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user['avatar']),
        radius: 24,
      ),
      title: Text(user['displayName']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('@${user['username']}'),
          if (user['mutualFriends'] > 0)
            Text(
              '${user['mutualFriends']} mutual ${user['mutualFriends'] == 1 ? 'friend' : 'friends'}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
      trailing: showFollowButton
          ? ElevatedButton(
              onPressed: () => _toggleFollowUser(user['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: user['isFollowing'] == true
                    ? Colors.grey[300]
                    : AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                user['isFollowing'] == true ? 'Following' : 'Follow',
                style: TextStyle(
                  color: user['isFollowing'] == true
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              userId: user['id'],
              displayName: user['displayName'],
              avatar: user['avatar'],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendRequestItem(Map<String, dynamic> request) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(request['avatar']),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['displayName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '@${request['username']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      if (request['mutualFriends'] > 0)
                        Text(
                          '${request['mutualFriends']} mutual ${request['mutualFriends'] == 1 ? 'friend' : 'friends'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (request['bio'] != null && request['bio'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  request['bio'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => _handleFriendRequest(request['id'], false),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  child: const Text('Decline'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _handleFriendRequest(request['id'], true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedFriendItem(Map<String, dynamic> friend) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(friend['avatar']),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend['displayName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '@${friend['username']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      if (friend['mutualFriends'] > 0)
                        Text(
                          '${friend['mutualFriends']} mutual ${friend['mutualFriends'] == 1 ? 'friend' : 'friends'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (friend['bio'] != null && friend['bio'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  friend['bio'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            if (friend['commonInterests'] != null &&
                (friend['commonInterests'] as List).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                child: Row(
                  children: [
                    Text(
                      'Common interests: ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        children: (friend['commonInterests'] as List)
                            .map((interest) => Chip(
                                  label: Text(
                                    interest,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor:
                                      AppTheme.primaryColor.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.zero,
                                  labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: -2,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
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
                  icon: const Icon(
                    Icons.message_outlined,
                    size: 20,
                  ),
                  label: const Text('Message'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _toggleFollowUser(friend['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: friend['isFollowing'] == true
                        ? Colors.grey[300]
                        : AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    friend['isFollowing'] == true ? 'Following' : 'Follow',
                    style: TextStyle(
                      color: friend['isFollowing'] == true
                          ? Colors.black87
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 