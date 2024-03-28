import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class AgriculturalNewsPage extends StatefulWidget {
  @override
  _AgriculturalNewsPageState createState() => _AgriculturalNewsPageState();
}

class _AgriculturalNewsPageState extends State<AgriculturalNewsPage> {
  late List<NewsArticle> _newsArticles;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchAgriculturalNews();
  }

  Future<void> _fetchAgriculturalNews() async {
    final apiKey = 'cfd53a5e9emsh54221adbe4d7b8cp10fc0djsnfbff5ce2b6622';
    final apiUrl = 'https://newsapi90.p.rapidapi.com/search?query=farmer&language=en-IN&region=IN';

    final headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'newsapi90.p.rapidapi.com',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List<dynamic>) {
          final articles = responseData;

          setState(() {
            _newsArticles = List<NewsArticle>.from(articles.map((article) => NewsArticle.fromJson(article)));
            _loading = false;
            _error = false;
          });
        } else {
          print('Invalid response format. Expected a list.');
          setState(() {
            _loading = false;
            _error = true;
          });
        }
      } else {
        print('Failed to load news: ${response.reasonPhrase}');
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    } catch (error) {
      print('Error fetching news: $error');
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _refreshNews() async {
    await _fetchAgriculturalNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Farmer Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: _loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _error
          ? Center(
        child: Text(
          'Failed to load news.',
          style: TextStyle(color: Colors.red),
        ),
      )
          : RefreshIndicator(
        onRefresh: _refreshNews,
        child: ListView.builder(
          itemCount: _newsArticles.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(_newsArticles[index].title),
                subtitle: Text(_newsArticles[index].description),
                onTap: () {
                  _launchURL(_newsArticles[index].url);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class NewsArticle {
  final String title;
  final String description;
  final String url;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'N/A',
      description: json['description'] ?? 'No description available.',
      url: json['url'] ?? 'https://example.com', // Default URL if not present
    );
  }
}
