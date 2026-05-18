part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends PostEvent {
  const FetchPostsEvent();
}

class CreatePostEvent extends PostEvent {
  final int userId;
  final String title;
  final String body;

  const CreatePostEvent({
    required this.userId,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [userId, title, body];
}

class UpdatePostEvent extends PostEvent {
  final Post post;
  const UpdatePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

class DeletePostEvent extends PostEvent {
  final int postId;
  const DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
