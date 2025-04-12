import 'package:flutter/material.dart';
import 'package:mediamosaic/presentation/theme/app_theme.dart';
import 'package:mediamosaic/presentation/widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final bool _isLoggedIn = true; // Mock data - would come from auth state
  
  // Mock user data
  final Map<String, dynamic> _userData = {
    'username': 'mediamosaic_user',
    'displayName': 'Alex Johnson',
    'email': 'alex@example.com',
    'bio': 'Digital media enthusiast and content creator. Love to discover new content!',
    'profileImage': 'https://randomuser.me/api/portraits/women/44.jpg',
    'joinDate': DateTime(2023, 3, 15),
    'totalPosts': 47,
    'totalFavorites': 128,
    'followers': 342,
    'following': 215,
  };
  
  // Mock media stats
  final List<Map<String, dynamic>> _mediaStats = [
    {'type': 'News', 'count': 32, 'color': Colors.blue},
    {'type': 'Videos', 'count': 58, 'color': Colors.red},
    {'type': 'Memes', 'count': 21, 'color': Colors.purple},
    {'type': 'Tweets', 'count': 17, 'color': Colors.lightBlue},
  ];
  
  // Settings toggles
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;
  bool _dataCollectionEnabled = false;
  
  void _logout() {
    // Implement logout functionality
    // This would clear auth tokens, user data, etc.
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings or show settings dialog
            },
          ),
        ],
      ),
      body: _isLoggedIn ? _buildProfileContent() : _buildLoginPrompt(),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }
  
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          _buildProfileHeader(),
          
          // Stats section
          _buildStatsSection(),
          
          // Media activity section
          _buildMediaActivitySection(),
          
          // Settings section
          _buildSettingsSection(),
          
          // Logout button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Log Out'),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_userData['profileImage']),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 16),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userData['displayName'],
                      style: AppTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${_userData['username']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userData['bio'],
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Joined ${_getFormattedDate(_userData['joinDate'])}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Edit profile button
          OutlinedButton(
            onPressed: () {
              // Navigate to edit profile screen
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity',
            style: AppTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Posts', _userData['totalPosts'].toString()),
              _buildStatItem('Favorites', _userData['totalFavorites'].toString()),
              _buildStatItem('Followers', _userData['followers'].toString()),
              _buildStatItem('Following', _userData['following'].toString()),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMediaActivitySection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Media Activity',
            style: AppTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _mediaStats.length,
              itemBuilder: (context, index) {
                final stat = _mediaStats[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: stat['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: stat['color'].withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat['count'].toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: stat['color'],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stat['type'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: AppTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            'Dark Mode',
            'Switch to dark theme',
            _darkModeEnabled,
            (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          const Divider(),
          _buildSettingsItem(
            'Notifications',
            'Enable push notifications',
            _notificationsEnabled,
            (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          const Divider(),
          _buildSettingsItem(
            'Data Collection',
            'Allow anonymous data collection',
            _dataCollectionEnabled,
            (value) {
              setState(() {
                _dataCollectionEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsItem(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          Text(
            'Sign in to see your profile',
            style: AppTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const Text(
            'Create and manage your MediaMosaic account',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
            ),
            child: const Text('Sign In'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/register');
            },
            child: const Text('Create Account'),
          ),
        ],
      ),
    );
  }
  
  String _getFormattedDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June', 
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${months[date.month - 1]} ${date.year}';
  }
} 