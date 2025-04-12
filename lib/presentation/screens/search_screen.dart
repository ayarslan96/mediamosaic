import 'package:flutter/material.dart';
import 'package:mediamosaic/data/models/media_content_model.dart';
import 'package:mediamosaic/presentation/theme/app_theme.dart';
import 'package:mediamosaic/presentation/widgets/bottom_nav_bar.dart';
import 'package:mediamosaic/presentation/widgets/media_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _isLoading = false;
  List<MediaContent> _searchResults = [];
  
  // Selected filters
  final List<String> _selectedCategories = [];
  String? _selectedMediaType;
  String _sortBy = 'newest'; // Default sort
  
  // Available filter options
  final List<String> _categories = [
    'Technology', 'Entertainment', 'Sports', 'Politics', 
    'Science', 'Health', 'Travel', 'Food', 'Fashion'
  ];
  
  final Map<String, String> _sortOptions = {
    'newest': 'Newest First',
    'oldest': 'Oldest First',
    'popular': 'Most Popular',
    'relevant': 'Most Relevant',
  };
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text;
    });
  }
  
  Future<void> _performSearch() async {
    if (_query.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API search delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock search results
    final results = _generateMockSearchResults();
    
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }
  
  List<MediaContent> _generateMockSearchResults() {
    // This would be replaced with actual API calls in a real app
    final results = <MediaContent>[];
    
    // Generate some mock results based on the search query
    final int resultCount = 10 + (_query.length % 5);
    
    for (int i = 0; i < resultCount; i++) {
      final mediaType = MediaType.values[i % MediaType.values.length];
      final String imageUrl = 'https://picsum.photos/seed/${_query.hashCode + i}/400/300';
      
      results.add(MediaContent(
        id: i,
        title: 'Search result #$i for "$_query"',
        summary: 'This is a sample result that matches your search for $_query. '
                'This would show the actual content summary in a real app.',
        imageUrl: imageUrl,
        type: mediaType,
        publishedAt: DateTime.now().subtract(Duration(hours: i * 3)),
        sourceName: 'Source ${i % 5 + 1}',
        sourceUrl: 'https://example.com/source${i % 5 + 1}',
        likes: 10 + (i * 5),
        comments: 2 + (i * 2),
        categories: [_categories[i % _categories.length]],
      ));
    }
    
    // Apply filters
    var filteredResults = results.where((result) {
      // Filter by media type
      if (_selectedMediaType != null) {
        final selectedType = MediaType.values.firstWhere(
          (e) => e.toString() == 'MediaType.$_selectedMediaType',
          orElse: () => MediaType.news,
        );
        if (result.type != selectedType) return false;
      }
      
      // Filter by categories
      if (_selectedCategories.isNotEmpty) {
        bool hasCategory = false;
        for (final category in result.categories) {
          if (_selectedCategories.contains(category)) {
            hasCategory = true;
            break;
          }
        }
        if (!hasCategory) return false;
      }
      
      return true;
    }).toList();
    
    // Apply sorting
    filteredResults.sort((a, b) {
      switch (_sortBy) {
        case 'newest':
          return b.publishedAt.compareTo(a.publishedAt);
        case 'oldest':
          return a.publishedAt.compareTo(b.publishedAt);
        case 'popular':
          return (b.likes + b.comments).compareTo(a.likes + a.comments);
        case 'relevant':
        default:
          // Mock relevance - in a real app this would be based on search algorithm
          return (b.title.contains(_query) ? 10 : 0) - (a.title.contains(_query) ? 10 : 0);
      }
    });
    
    return filteredResults;
  }
  
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter Results',
                            style: AppTheme.headlineSmall,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const Divider(),
                      
                      // Filters
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            // Media Type Filter
                            _buildFilterSection(
                              'Media Type',
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  FilterChip(
                                    label: const Text('All'),
                                    selected: _selectedMediaType == null,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedMediaType = null;
                                      });
                                    },
                                  ),
                                  ...MediaType.values.map((type) {
                                    return FilterChip(
                                      label: Text(type.name.toString()),
                                      selected: _selectedMediaType == type.name,
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedMediaType = selected ? type.name : null;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                            
                            // Categories Filter
                            _buildFilterSection(
                              'Categories',
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _categories.map((category) {
                                  return FilterChip(
                                    label: Text(category),
                                    selected: _selectedCategories.contains(category),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedCategories.add(category);
                                        } else {
                                          _selectedCategories.remove(category);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            
                            // Sort Options
                            _buildFilterSection(
                              'Sort By',
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _sortOptions.entries.map((entry) {
                                  return ChoiceChip(
                                    label: Text(entry.value),
                                    selected: _sortBy == entry.key,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _sortBy = entry.key;
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Apply and Reset Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedCategories.clear();
                                  _selectedMediaType = null;
                                  _sortBy = 'newest';
                                });
                              },
                              child: const Text('Reset'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // This will apply the filters by rebuilding the screen
                                this.setState(() {});
                                _performSearch();
                              },
                              child: const Text('Apply Filters'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  
  Widget _buildFilterSection(String title, {required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for media...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchResults.clear();
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterBottomSheet,
                  tooltip: 'Filter',
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Active filters display
          if (_selectedCategories.isNotEmpty || _selectedMediaType != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_list,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Filters: ${_getActiveFiltersText()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategories.clear();
                        _selectedMediaType = null;
                        _sortBy = 'newest';
                        _performSearch();
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(4),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
          
          // Search content
          Expanded(
            child: _buildSearchContent(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
  
  String _getActiveFiltersText() {
    final List<String> filters = [];
    
    if (_selectedMediaType != null) {
      filters.add('Type: $_selectedMediaType');
    }
    
    if (_selectedCategories.isNotEmpty) {
      filters.add('Categories: ${_selectedCategories.join(", ")}');
    }
    
    filters.add('Sort: ${_sortOptions[_sortBy]}');
    
    return filters.join(' • ');
  }
  
  Widget _buildSearchContent() {
    if (_query.isEmpty) {
      return _buildSearchSuggestions();
    }
    
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "$_query"',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MediaCard(
            mediaContent: item,
            onTap: () {
              Navigator.of(context).pushNamed(
                '/detail',
                arguments: item,
              );
            },
          ),
        );
      },
    );
  }
  
  Widget _buildSearchSuggestions() {
    // These would be personalized in a real app based on user history
    final List<String> recentSearches = [
      'Breaking news',
      'Trending memes',
      'Technology reviews',
      'Sports highlights',
    ];
    
    final List<String> trendingSearches = [
      'Climate change',
      'Artificial intelligence',
      'Viral videos',
      'Space exploration',
      'Health tips',
    ];
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Recent searches
        Text(
          'Recent Searches',
          style: AppTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: recentSearches.map((search) {
            return ActionChip(
              avatar: const Icon(
                Icons.history,
                size: 16,
              ),
              label: Text(search),
              onPressed: () {
                _searchController.text = search;
                _performSearch();
              },
            );
          }).toList(),
        ),
        
        const SizedBox(height: 24),
        
        // Trending searches
        Text(
          'Trending',
          style: AppTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...trendingSearches.map((search) {
          return ListTile(
            leading: const Icon(Icons.trending_up),
            title: Text(search),
            onTap: () {
              _searchController.text = search;
              _performSearch();
            },
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ],
    );
  }
} 