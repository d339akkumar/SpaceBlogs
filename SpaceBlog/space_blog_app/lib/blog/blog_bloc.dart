import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  final String adminSecret =
      '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

  List<dynamic> _allBlogs = [];
  List<int> _favorites = [];

  BlogBloc() : super(BlogInitial()) {
    on<FetchBlogs>(_onFetchBlogs);
    on<MarkFavorite>(_onMarkFavorite);
  }

  Future<void> _onFetchBlogs(FetchBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = json.decode(response.body);
        final List<dynamic> blogs = decodedResponse['blogs'] ?? [];
        _allBlogs = blogs;
        emit(BlogLoaded(_allBlogs, _favorites));
      } else {
        emit(BlogError('Failed to load blogs'));
      }
    } catch (e) {
      emit(BlogError('Error: $e'));
    }
  }

  void _onMarkFavorite(MarkFavorite event, Emitter<BlogState> emit) {
    if (_favorites.contains(event.blogId)) {
      _favorites.remove(event.blogId);
    } else {
      _favorites.add(event.blogId);
    }
    emit(BlogLoaded(_allBlogs, _favorites));
  }
}
