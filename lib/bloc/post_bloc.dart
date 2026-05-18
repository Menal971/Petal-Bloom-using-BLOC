import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/post.dart';
import '../services/api_service.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final ApiService _api;

  PostBloc({ApiService? apiService})
      : _api = apiService ?? ApiService(),
        super(const PostInitial()) {
    on<FetchPostsEvent>(_onFetch);
    on<CreatePostEvent>(_onCreate);
    on<UpdatePostEvent>(_onUpdate);
    on<DeletePostEvent>(_onDelete);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  List<Post> get _currentPosts {
    final s = state;
    if (s is PostLoaded) return List<Post>.from(s.posts);
    if (s is PostMutating) return List<Post>.from(s.posts);
    if (s is PostMutationSuccess) return List<Post>.from(s.posts);
    if (s is PostError) return List<Post>.from(s.posts);
    return [];
  }

  // ── Fetch ─────────────────────────────────────────────────────────────────

  Future<void> _onFetch(
      FetchPostsEvent event, Emitter<PostState> emit) async {
    emit(const PostLoading());
    try {
      final posts = await _api.fetchPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  Future<void> _onCreate(
      CreatePostEvent event, Emitter<PostState> emit) async {
    final current = _currentPosts;
    emit(PostMutating(current));
    try {
      final created = await _api.createPost(
        userId: event.userId,
        title: event.title,
        body: event.body,
      );
      // Assign local unique id to avoid duplicates with JSONPlaceholder's id=101
      final localId = current.isEmpty
          ? -1
          : current.map((p) => p.id).reduce((a, b) => a < b ? a : b) - 1;
      final newPost = created.copyWith(id: localId);
      final updated = [newPost, ...current];
      emit(PostMutationSuccess(updated, '🌸 Note created!'));
    } catch (e) {
      emit(PostError(
        e.toString().replaceFirst('Exception: ', ''),
        posts: current,
      ));
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<void> _onUpdate(
      UpdatePostEvent event, Emitter<PostState> emit) async {
    final current = _currentPosts;
    emit(PostMutating(current));
    try {
      final updated = await _api.updatePost(event.post);
      final list = current
          .map((p) => p.id == event.post.id
              ? updated.copyWith(id: event.post.id)
              : p)
          .toList();
      emit(PostMutationSuccess(list, '✏️ Note updated!'));
    } catch (e) {
      emit(PostError(
        e.toString().replaceFirst('Exception: ', ''),
        posts: current,
      ));
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> _onDelete(
      DeletePostEvent event, Emitter<PostState> emit) async {
    final current = _currentPosts;
    emit(PostMutating(current));
    try {
      await _api.deletePost(event.postId);
      final list = current.where((p) => p.id != event.postId).toList();
      emit(PostMutationSuccess(list, '🗑️ Note deleted'));
    } catch (e) {
      emit(PostError(
        e.toString().replaceFirst('Exception: ', ''),
        posts: current,
      ));
    }
  }
}
