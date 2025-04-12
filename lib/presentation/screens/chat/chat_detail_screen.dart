import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediamosaic/presentation/theme/app_theme.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userId;
  final String displayName;
  final String avatar;

  const ChatDetailScreen({
    super.key,
    required this.userId,
    required this.displayName,
    required this.avatar,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final mockMessages = [
        {
          'id': '1',
          'senderId': widget.userId,
          'text': 'Hey there! How are you doing?',
          'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          'isRead': true,
        },
        {
          'id': '2',
          'senderId': 'currentUser',
          'text': 'I\'m good, thanks! Just exploring some new content on MediaMosaic.',
          'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 55)),
          'isRead': true,
        },
        {
          'id': '3',
          'senderId': widget.userId,
          'text': 'Oh, anything interesting you found?',
          'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 50)),
          'isRead': true,
        },
        {
          'id': '4',
          'senderId': 'currentUser',
          'text': 'Yes! I found this amazing documentary series. Let me share it with you.',
          'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 45)),
          'isRead': true,
        },
        {
          'id': '5',
          'senderId': 'currentUser',
          'mediaContent': {
            'id': 'm1',
            'title': 'Our Planet: Hidden Worlds',
            'imageUrl': 'https://picsum.photos/seed/picsum/300/200',
            'category': 'Documentary',
            'rating': 4.8,
          },
          'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 44)),
          'isRead': true,
        },
        {
          'id': '6',
          'senderId': widget.userId,
          'text': 'That looks amazing! I\'ll definitely check it out. Thanks for sharing!',
          'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 40)),
          'isRead': true,
        },
        {
          'id': '7',
          'senderId': 'currentUser',
          'text': 'No problem! What have you been watching lately?',
          'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
          'isRead': true,
        },
        {
          'id': '8',
          'senderId': widget.userId,
          'text': 'I\'ve been watching this new sci-fi series. It\'s quite mind-bending!',
          'timestamp': DateTime.now().subtract(const Duration(hours: 4, minutes: 55)),
          'isRead': true,
        },
        {
          'id': '9',
          'senderId': widget.userId,
          'mediaContent': {
            'id': 'm2',
            'title': 'Nebula: Beyond Time',
            'imageUrl': 'https://picsum.photos/seed/scifi/300/200',
            'category': 'Sci-Fi',
            'rating': 4.6,
          },
          'timestamp': DateTime.now().subtract(const Duration(hours: 4, minutes: 54)),
          'isRead': true,
        },
        {
          'id': '10',
          'senderId': 'currentUser',
          'text': 'Oh, I\'ve heard about that one! Is it as good as they say?',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
          'isRead': true,
        },
      ];

      setState(() {
        _messages.addAll(mockMessages);
        _isLoading = false;
      });

      // Scroll to bottom after messages load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load messages: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'senderId': 'currentUser',
      'text': text,
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Simulate typing indicator from the other user
    if (_messages.length % 3 == 0) {
      _simulateTypingIndicator();
    }

    _scrollToBottom();
  }

  void _simulateTypingIndicator() async {
    setState(() {
      _isTyping = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'senderId': widget.userId,
          'text': 'That\'s interesting! Tell me more about it.',
          'timestamp': DateTime.now(),
          'isRead': false,
        });
      });

      _scrollToBottom();
    }
  }

  void _shareMediaContent() {
    // Simulate sharing a media content
    final mockMediaContent = {
      'id': 'm3',
      'title': 'Cosmos: A Spacetime Odyssey',
      'imageUrl': 'https://picsum.photos/seed/cosmos/300/200',
      'category': 'Science',
      'rating': 4.9,
    };

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'senderId': 'currentUser',
      'mediaContent': mockMediaContent,
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.avatar),
              radius: 18,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isTyping)
                  const Text(
                    'typing...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                else
                  const Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice call feature coming soon!'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video call feature coming soon!'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildOptionsBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? const Center(
                          child: Text('No messages yet. Start the conversation!'),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            final isCurrentUser = message['senderId'] == 'currentUser';
                            final showAvatar = index == 0 ||
                                _messages[index - 1]['senderId'] != message['senderId'];
                            final showTimestamp = index == _messages.length - 1 ||
                                _messages[index + 1]['senderId'] != message['senderId'];

                            return _buildMessageItem(
                              message,
                              isCurrentUser,
                              showAvatar,
                              showTimestamp,
                            );
                          },
                        ),
                ),
                _buildInputArea(),
              ],
            ),
    );
  }

  Widget _buildMessageItem(
    Map<String, dynamic> message,
    bool isCurrentUser,
    bool showAvatar,
    bool showTimestamp,
  ) {
    final hasMediaContent = message.containsKey('mediaContent');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser && showAvatar)
            CircleAvatar(
              backgroundImage: NetworkImage(widget.avatar),
              radius: 16,
            )
          else if (!isCurrentUser && !showAvatar)
            const SizedBox(width: 32),
          
          const SizedBox(width: 8),
          
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (hasMediaContent)
                  _buildMediaContentMessage(
                    message['mediaContent'],
                    isCurrentUser,
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? AppTheme.primaryColor
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: isCurrentUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                
                if (showTimestamp)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _formatMessageTime(message['timestamp']),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          if (isCurrentUser && showAvatar)
            const CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              radius: 16,
              child: Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            )
          else if (isCurrentUser && !showAvatar)
            const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildMediaContentMessage(
    Map<String, dynamic> mediaContent,
    bool isCurrentUser,
  ) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppTheme.primaryColor.withOpacity(0.8)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              mediaContent['imageUrl'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mediaContent['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCurrentUser ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mediaContent['category'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isCurrentUser
                            ? Colors.white.withOpacity(0.8)
                            : Colors.grey[700],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: isCurrentUser
                              ? Colors.white
                              : Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          mediaContent['rating'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: isCurrentUser
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to media detail screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening media content...'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrentUser
                        ? Colors.white
                        : AppTheme.primaryColor,
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      color: isCurrentUser
                          ? AppTheme.primaryColor
                          : Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              color: AppTheme.primaryColor,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildAttachmentsBottomSheet(),
                );
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsBottomSheet() {
    final attachmentOptions = [
      {
        'icon': Icons.image,
        'label': 'Gallery',
        'onTap': () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gallery feature coming soon!'),
            ),
          );
        },
      },
      {
        'icon': Icons.camera_alt,
        'label': 'Camera',
        'onTap': () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera feature coming soon!'),
            ),
          );
        },
      },
      {
        'icon': Icons.video_library,
        'label': 'Video',
        'onTap': () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Video feature coming soon!'),
            ),
          );
        },
      },
      {
        'icon': Icons.location_on,
        'label': 'Location',
        'onTap': () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location feature coming soon!'),
            ),
          );
        },
      },
      {
        'icon': Icons.movie,
        'label': 'Media',
        'onTap': () {
          Navigator.pop(context);
          _shareMediaContent();
        },
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Share',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: attachmentOptions.length,
              itemBuilder: (context, index) {
                final option = attachmentOptions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: option['onTap'] as Function(),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            option['icon'] as IconData,
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option['label'] as String,
                        style: const TextStyle(fontSize: 12),
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

  Widget _buildOptionsBottomSheet() {
    final options = [
      {
        'icon': Icons.search,
        'label': 'Search',
        'onTap': () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Search feature coming soon!'),
            ),
          );
        },
      },
      {
        'icon': Icons.notifications_off,
        'label': 'Mute',
        'onTap': () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mute feature coming soon!'),
            ),
          );
        },
      },
      {
        'icon': Icons.delete,
        'label': 'Delete',
        'onTap': () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Delete feature coming soon!'),
            ),
          );
        },
      },
      {
        'icon': Icons.block,
        'label': 'Block',
        'onTap': () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Block feature coming soon!'),
            ),
          );
        },
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Chat Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return ListTile(
                leading: Icon(
                  option['icon'] as IconData,
                  color: option['label'] == 'Block' || option['label'] == 'Delete'
                      ? Colors.red
                      : Colors.grey[700],
                ),
                title: Text(option['label'] as String),
                onTap: option['onTap'] as Function(),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    } else {
      return DateFormat('h:mm a').format(timestamp);
    }
  }
} 