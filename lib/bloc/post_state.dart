part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
  @override
  List<Object?> get props => [];
}

/// Initial / idle
class PostInitial extends PostState {
  const PostInitial();
}

/// Fetching list
class PostLoading extends PostState {
  const PostLoading();
}

/// List loaded successfully
class PostLoaded extends PostState {
  final List<Post> posts;
  const PostLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

/// A CRUD mutation is in progress (create / update / delete)
class PostMutating extends PostState {
  final List<Post> posts; // keep showing current list while mutating
  const PostMutating(this.posts);

  @override
  List<Object?> get props => [posts];
}

/// Mutation succeeded
class PostMutationSuccess extends PostState {
  final List<Post> posts;
  final String message;
  const PostMutationSuccess(this.posts, this.message);

  @override
  List<Object?> get props => [posts, message];
}

/// Any operation failed
class PostError extends PostState {
  final String message;
  final List<Post> posts; // keep list if already loaded
  const PostError(this.message, {this.posts = const []});

  @override
  List<Object?> get props => [message, posts];
}
