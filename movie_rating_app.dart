import 'package:flutter/material.dart';

void main() => runApp(MovieRatingApp());

class Movie {
  final String title;
  final String imageUrl;
  double rating;

  Movie({
    required this.title,
    required this.imageUrl,
    this.rating = 0,
  });
}

class MovieRatingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Rating App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> movies = [
    Movie(
      title: "Inception",
      imageUrl: "https://picsum.photos/id/1011/400/200",
    ),
    Movie(
      title: "Interstellar",
      imageUrl: "https://picsum.photos/id/1012/400/200",
    ),
    Movie(
      title: "The Dark Knight",
      imageUrl: "https://picsum.photos/id/1013/400/200",
    ),
    Movie(
      title: "Avengers: Endgame",
      imageUrl: "https://picsum.photos/id/1015/400/200",
    ),
  ];

  void updateRating(int index, double rating) {
    setState(() {
      movies[index].rating = rating;
    });
  }

  Widget buildStarRow(double rating, int index) {
    return Row(
      children: List.generate(5, (i) {
        return IconButton(
          icon: Icon(
            i < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => updateRating(index, i + 1.0),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Rating App"),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      movie.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey.shade300,
                        child: Center(child: Icon(Icons.broken_image, size: 60)),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      buildStarRow(movie.rating, index),
                      Text("Rating: ${movie.rating.toStringAsFixed(1)} / 5"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
