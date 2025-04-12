import 'package:flutter/material.dart';
import 'package:mediamosaic/data/models/media_content_model.dart';
import 'package:share_plus/share_plus.dart';

class MediaDetailScreen extends StatefulWidget {
  final MediaContent mediaContent;

  const MediaDetailScreen({
    super.key,
    required this.mediaContent,
  });

  @override
  State<MediaDetailScreen> createState() => _MediaDetailScreenState();
}

class _MediaDetailScreenState extends State<MediaDetailScreen> {
  bool _isFavorite = false;
  int _likeCount = 0;
  
  @override
  void initState() {
    super.initState();
    _isFavorite = widget.mediaContent.isFavorite;
    _likeCount = widget.mediaContent.likes;
  }
  
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      _likeCount += _isFavorite ? 1 : -1;
    });
    // In a real app, you would update this in your database or API
    // mediaRepository.toggleFavorite(widget.mediaContent.id);
  }
  
  void _shareContent() {
    final mediaTitle = widget.mediaContent.title;
    final sourceUrl = widget.mediaContent.sourceUrl ?? 'https://mediamosaic.app';
    Share.share('Check out this content: $mediaTitle\n$sourceUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with image as background
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.mediaContent.type.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image or placeholder
                  widget.mediaContent.imageUrl != null
                      ? Image.network(
                          widget.mediaContent.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: _getMediaTypeColor(widget.mediaContent.type),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.white70,
                                  size: 64,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: _getMediaTypeColor(widget.mediaContent.type),
                          child: Center(
                            child: Icon(
                              _getMediaTypeIcon(widget.mediaContent.type),
                              color: Colors.white70,
                              size: 64,
                            ),
                          ),
                        ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareContent,
              ),
            ],
          ),
          
          // Content body
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and publisher info
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mediaContent.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            widget.mediaContent.sourceName ?? 'Unknown source',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getFormattedDate(widget.mediaContent.publishedAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Interaction bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : null,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                      Text(
                        _likeCount.toString(),
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.mediaContent.comments.toString(),
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      _buildCategoryChip(
                        widget.mediaContent.categories.isNotEmpty
                            ? widget.mediaContent.categories.first
                            : 'Uncategorized',
                      ),
                    ],
                  ),
                ),
                
                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Colors.grey[300]),
                ),
                
                // Content summary
                if (widget.mediaContent.summary != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Text(
                      widget.mediaContent.summary!,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                
                // Related media section (mock data for demonstration)
                _buildRelatedMediaSection(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.thumb_up_outlined),
              onPressed: _toggleFavorite,
              tooltip: 'Like',
            ),
            IconButton(
              icon: const Icon(Icons.comment_outlined),
              onPressed: () {
                // Open comments section
              },
              tooltip: 'Comment',
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: _shareContent,
              tooltip: 'Share',
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {
                // Save for later functionality
              },
              tooltip: 'Save',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _buildRelatedMediaSection() {
    // Mock data for demonstration
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'More Like This',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5, // Mock items count
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      child: Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            _getMediaTypeIcon(widget.mediaContent.type),
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Related item ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
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
  
  IconData _getMediaTypeIcon(MediaType type) {
    switch (type) {
      case MediaType.news:
        return Icons.article_outlined;
      case MediaType.video:
        return Icons.videocam_outlined;
      case MediaType.meme:
        return Icons.image_outlined;
      case MediaType.tweet:
        return Icons.chat_outlined;
    }
  }
  
  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 30) {
      // Format as month day, year
      return '${date.month}/${date.day}/${date.year}';
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