part of 'blog_bloc.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class FetchBlogs extends BlogEvent {}

class MarkFavorite extends BlogEvent {
  final int blogId;

  MarkFavorite(this.blogId);

  @override
  List<Object> get props => [blogId];
}
