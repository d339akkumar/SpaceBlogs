part of 'blog_bloc.dart';

abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLoaded extends BlogState {
  final List<dynamic> blogs;
  final List<int> favorites;

  BlogLoaded(this.blogs, this.favorites);

  @override
  List<Object> get props => [blogs, favorites];
}

class BlogError extends BlogState {
  final String message;

  BlogError(this.message);

  @override
  List<Object> get props => [message];
}
