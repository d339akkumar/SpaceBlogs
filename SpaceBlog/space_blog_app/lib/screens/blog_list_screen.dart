import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blog/blog_bloc.dart';
import 'blog_detail_screen.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(FetchBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SpaceBlog',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BlogLoaded) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                // Ensure the blog ID is valid
                if (blog['id'] == -1) return Container();
                final isFavorite = state.favorites.contains(blog['id']);
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlogDetailScreen(blog: blog),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            blog['image_url'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200.0, // Adjust height as needed
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        blog['title'],
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      SizedBox(height: 4.0),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          try {
                            int blogId = int.parse(blog['id']);
                            context.read<BlogBloc>().add(MarkFavorite(blogId));
                          } catch (e) {
                            print('Error parsing blog ID: $e');
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is BlogError) {
            return Center(
                child:
                    Text(state.message, style: TextStyle(color: Colors.white)));
          }
          return Container();
        },
      ),
    );
  }
}
