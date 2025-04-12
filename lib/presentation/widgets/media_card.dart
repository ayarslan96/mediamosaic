import 'package:flutter/material.dart';
import 'package:mediamosaic/data/models/media_content_model.dart';

class MediaCard extends StatelessWidget {
  final MediaContent mediaContent;
  final VoidCallback onTap;

  const MediaCard({
    super.key,
    required this.mediaContent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Image
            if (mediaContent.imageUrl != null)
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      mediaContent.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                  // Media type badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getMediaTypeColor(mediaContent.type),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        mediaContent.type.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      _getMediaTypeIcon(mediaContent.type),
                      color: Colors.grey,
                      size: 32,
                    ),
                  ),
                ),
              ),
            
            // Content details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      mediaContent.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Source & Date
                    if (mediaContent.sourceName != null) ...[
                      Text(
                        mediaContent.sourceName!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                    ],
                    
                    Text(
                      _getFormattedDate(mediaContent.publishedAt),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Likes and comments
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mediaContent.likes.toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mediaContent.comments.toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}