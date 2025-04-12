import 'package:flutter/material.dart';
import 'package:mediamosaic/core/theme/app_theme.dart';
import 'package:mediamosaic/data/models/media_content_model.dart';
import 'package:mediamosaic/presentation/widgets/bottom_nav_bar.dart';
import 'package:mediamosaic/presentation/widgets/media_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final List<MediaContent> _mediaItems = [];
  
  @override
  void initState() {
    super.initState();
    _loadInitialData();
    
    // Add scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreData();
      }
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Add mock data
      final mockData = _generateMockMediaItems();
      setState(() {
        _mediaItems.addAll(mockData);
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
  
  Future<void> _loadMoreData() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Add more mock data
      final mockData = _generateMockMediaItems();
      setState(() {
        _mediaItems.addAll(mockData);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  List<MediaContent> _generateMockMediaItems() {
    // Create some mock media content
    final now = DateTime.now();
    return [
      MediaContent(
        id: _mediaItems.length + 1,
        type: MediaType.news,
        title: 'Flutter 3.0 Released: What\'s New?',
        summary: 'The latest version of Flutter brings performance improvements and new features.',
        imageUrl: 'https://picsum.photos/id/${_mediaItems.length + 1}/400/250',
        publishedAt: now.subtract(const Duration(hours: 2)),
        sourceName: 'Tech Daily',
        categories: const ['Technology'],
        likes: 45,
        comments: 12,
      ),
      MediaContent(
        id: _mediaItems.length + 2,
        type: MediaType.video,
        title: 'Building UIs with Flutter',
        summary: 'Learn how to create beautiful user interfaces in Flutter.',
        imageUrl: 'https://picsum.photos/id/${_mediaItems.length + 2}/400/250',
        publishedAt: now.subtract(const Duration(hours: 5)),
        sourceName: 'Flutter Channel',
        categories: const ['Programming'],
        likes: 120,
        comments: 34,
      ),
      MediaContent(
        id: _mediaItems.length + 3,
        type: MediaType.meme,
        title: 'When your code finally works',
        imageUrl: 'https://picsum.photos/id/${_mediaItems.length + 3}/400/250',
        publishedAt: now.subtract(const Duration(hours: 8)),
        categories: const ['Humor'],
        likes: 890,
        comments: 76,
      ),
      MediaContent(
        id: _mediaItems.length + 4,
        type: MediaType.tweet,
        title: 'Just launched a new app! #Flutter #MobileApp',
        summary: 'Excited to announce our new app built with Flutter is now available on both App Store and Google Play. Download it today!',
        publishedAt: now.subtract(const Duration(hours: 12)),
        sourceName: '@FlutterDev',
        likes: 234,
        comments: 45,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediaMosaic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _mediaItems.clear();
          await _loadInitialData();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Category tabs
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip('All', true),
                    _buildCategoryChip('News', false),
                    _buildCategoryChip('Videos', false),
                    _buildCategoryChip('Memes', false),
                    _buildCategoryChip('Tweets', false),
                    _buildCategoryChip('Technology', false),
                    _buildCategoryChip('Entertainment', false),
                  ],
                ),
              ),
            ),
            
            // Featured content
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade200,
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/id/237/800/350'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Featured: The Future of Mobile Development',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Explore new trends and technologies',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Media content grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _mediaItems.length) {
                      return MediaCard(
                        mediaContent: _mediaItems[index],
                        onTap: () {
                          // Navigate to detail screen
                        },
                      );
                    }
                    return null;
                  },
                  childCount: _mediaItems.length,
                ),
              ),
            ),
            
            // Loading indicator
            SliverToBoxAdapter(
              child: _isLoading
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : const SizedBox(height: 80),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
  
  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? AppTheme.primaryColor : null,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : null,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
} 