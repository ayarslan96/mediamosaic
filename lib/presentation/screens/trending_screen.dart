import 'package:flutter/material.dart';
import 'package:mediamosaic/data/models/media_content_model.dart';
import 'package:mediamosaic/presentation/theme/app_theme.dart';
import 'package:mediamosaic/presentation/widgets/bottom_nav_bar.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  
  // Mock data for different trending categories
  final Map<String, List<MediaContent>> _trendingData = {
    'today': [],
    'week': [],
    'month': [],
  };
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTrendingData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadTrendingData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Generate mock data for each tab
      final todayData = _generateMockTrendingItems(12, 'Today');
      final weekData = _generateMockTrendingItems(15, 'This Week');
      final monthData = _generateMockTrendingItems(20, 'This Month');
      
      setState(() {
        _trendingData['today'] = todayData;
        _trendingData['week'] = weekData;
        _trendingData['month'] = monthData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load trending content: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  List<MediaContent> _generateMockTrendingItems(int count, String period) {
    final now = DateTime.now();
    final items = <MediaContent>[];
    
    for (int i = 0; i < count; i++) {
      final mediaType = MediaType.values[i % MediaType.values.length];
      final likesMultiplier = period == 'Today' ? 1 : (period == 'This Week' ? 5 : 15);
      final commentsMultiplier = period == 'Today' ? 1 : (period == 'This Week' ? 3 : 10);
      
      items.add(MediaContent(
        id: i + 100,
        type: mediaType,
        title: 'Trending ${mediaType.name} ${i + 1} - $period',
        summary: 'This is a trending content item for $period with high engagement.',
        imageUrl: 'https://picsum.photos/seed/${i + period.hashCode}/400/250',
        publishedAt: now.subtract(Duration(hours: i * 3)),
        sourceName: 'Trending Source ${i % 5 + 1}',
        sourceUrl: 'https://example.com/trending/${i + 1}',
        likes: 100 + (i * 20 * likesMultiplier),
        comments: 25 + (i * 5 * commentsMultiplier),
        shares: 15 + (i * 3),
        categories: _getRandomCategories(),
      ));
    }
    
    // Sort by engagement (likes + comments)
    items.sort((a, b) => (b.likes + b.comments) - (a.likes + a.comments));
    
    return items;
  }
  
  List<String> _getRandomCategories() {
    final categories = [
      'Entertainment',
      'Technology',
      'Sports',
      'Science',
      'Politics',
      'Health',
      'Travel',
      'Food',
      'Fashion',
    ];
    
    final selectedCount = 1 + (DateTime.now().millisecond % 2);
    final result = <String>[];
    
    for (int i = 0; i < selectedCount; i++) {
      final index = (DateTime.now().microsecond + i) % categories.length;
      result.add(categories[index]);
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'This Month'),
          ],
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTrendingList('today'),
                _buildTrendingList('week'),
                _buildTrendingList('month'),
              ],
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
  
  Widget _buildTrendingList(String period) {
    final items = _trendingData[period] ?? [];
    
    if (items.isEmpty) {
      return const Center(
        child: Text('No trending content available'),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadTrendingData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length + 1, // +1 for the header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildTrendingHeader(period);
          }
          
          final item = items[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTrendingItem(item, index - 1),
          );
        },
      ),
    );
  }
  
  Widget _buildTrendingHeader(String period) {
    String title;
    String description;
    
    switch (period) {
      case 'today':
        title = 'Today\'s Hottest Content';
        description = 'See what\'s trending in the last 24 hours';
        break;
      case 'week':
        title = 'Weekly Hits';
        description = 'The most popular content from this week';
        break;
      case 'month':
        title = 'Monthly Favorites';
        description = 'Top content from the past month';
        break;
      default:
        title = 'Trending Content';
        description = 'Popular content you might enjoy';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
  
  Widget _buildTrendingItem(MediaContent item, int rank) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/detail',
          arguments: item,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                // Image
                if (item.imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      item.imageUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                
                // Rank badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '#${rank + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Media type badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getMediaTypeColor(item.type),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.type.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (item.summary != null) ...[
                    Text(
                      item.summary!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Statistics
                  Row(
                    children: [
                      _buildStatItem(Icons.favorite, item.likes.toString()),
                      const SizedBox(width: 16),
                      _buildStatItem(Icons.chat_bubble_outline, item.comments.toString()),
                      const SizedBox(width: 16),
                      _buildStatItem(Icons.share, item.shares.toString()),
                      const Spacer(),
                      Text(
                        _getTimeAgo(item.publishedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Color _getMediaTypeColor(MediaType type) {
    switch (type) {
      case MediaType.news:
        return Colors.blue;
      case MediaType.video:
        return Colors.red;
      case MediaType.meme:
        return Colors.purple;
      case MediaType.tweet:
        return Colors.lightBlue;
    }
  }
  
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
} 