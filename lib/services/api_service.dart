import 'package:dio/dio.dart';
import '../models/post.dart';

class ApiService {
  late final Dio _dio;

  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // ignore: avoid_print
          print('[DIO] ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          // ignore: avoid_print
          print('[DIO] Response ${response.statusCode}');
          handler.next(response);
        },
        onError: (DioException e, handler) {
          // ignore: avoid_print
          print('[DIO] Error: ${e.message}');
          handler.next(e);
        },
      ),
    );
  }

  // READ — fetch all posts (limited to 20)
  Future<List<Post>> fetchPosts() async {
    try {
      final response =
          await _dio.get('/posts', queryParameters: {'_limit': 20});
      final List data = response.data as List;
      return data.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // CREATE — create a new post
  Future<Post> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      final response = await _dio.post(
        '/posts',
        data: {'userId': userId, 'title': title, 'body': body},
      );
      return Post.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // UPDATE — update a post by id
  Future<Post> updatePost(Post post) async {
    try {
      final response =
          await _dio.put('/posts/${post.id}', data: post.toJson());
      return Post.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE — delete a post by id
  Future<void> deletePost(int id) async {
    try {
      await _dio.delete('/posts/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timed out. Check your internet.');
      case DioExceptionType.badResponse:
        return Exception(
            'Server error: ${e.response?.statusCode ?? 'unknown'}');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception(e.message ?? 'An unexpected error occurred.');
    }
  }
}
