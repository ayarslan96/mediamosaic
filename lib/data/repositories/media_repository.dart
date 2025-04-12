import 'dart:convert';
import 'package:mediamosaic/data/models/media_content_model.dart';
import 'package:mediamosaic/data/services/api_service.dart';
import 'package:mediamosaic/data/services/storage_service.dart';

class MediaRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  MediaRepository({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  // Fetch media content by type and category
  Future<List<MediaContent>> getMediaContent({
    required MediaType type,
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        'media',
        queryParams: {
          'type': type.value,
          if (category != null) 'category': category,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((item) => MediaContent.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load media content: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to cached data if available
      final cachedData = await _storageService.get('media_${type.value}_${category ?? 'all'}_$page');
      if (cachedData != null) {
        final List<dynamic> data = json.decode(cachedData);
        return data.map((item) => MediaContent.fromJson(item)).toList();
      }
      rethrow;
    }
  }

  // Fetch recommended media content for user
  Future<List<MediaContent>> getRecommendedContent({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        'media/recommended',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        final mediaList = data.map((item) => MediaContent.fromJson(item)).toList();
        
        // Cache the data for offline use
        await _storageService.set(
          'recommended_media_$page',
          json.encode(data),
        );
        
        return mediaList;
      } else {
        throw Exception('Failed to load recommended content: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to cached recommendations
      final cachedData = await _storageService.get('recommended_media_$page');
      if (cachedData != null) {
        final List<dynamic> data = json.decode(cachedData);
        return data.map((item) => MediaContent.fromJson(item)).toList();
      }
      rethrow;
    }
  }

  // Search media content
  Future<List<MediaContent>> searchMedia({
    required String query,
    List<MediaType>? types,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (types != null && types.isNotEmpty) {
        queryParams['types'] = types.map((t) => t.value).join(',');
      }

      final response = await _apiService.get('media/search', queryParams: queryParams);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((item) => MediaContent.fromJson(item)).toList();
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get media details
  Future<MediaContent> getMediaDetails(int id) async {
    try {
      final response = await _apiService.get('media/$id');

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return MediaContent.fromJson(data);
      } else {
        throw Exception('Failed to load media details: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to cached details if available
      final cachedData = await _storageService.get('media_details_$id');
      if (cachedData != null) {
        return MediaContent.fromJson(json.decode(cachedData));
      }
      rethrow;
    }
  }

  // Like media content
  Future<bool> likeMedia(int id) async {
    try {
      final response = await _apiService.post('media/$id/like');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to like media: $e');
    }
  }

  // Unlike media content
  Future<bool> unlikeMedia(int id) async {
    try {
      final response = await _apiService.post('media/$id/unlike');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to unlike media: $e');
    }
  }

  // Save media for later
  Future<bool> saveMedia(int id) async {
    try {
      final response = await _apiService.post('media/$id/save');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to save media: $e');
    }
  }

  // Unsave media
  Future<bool> unsaveMedia(int id) async {
    try {
      final response = await _apiService.post('media/$id/unsave');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to unsave media: $e');
    }
  }

  // Get saved media content
  Future<List<MediaContent>> getSavedMedia({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        'media/saved',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((item) => MediaContent.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load saved media: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
} 