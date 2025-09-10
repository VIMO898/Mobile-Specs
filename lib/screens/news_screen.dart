import 'package:app/widgets/news/latest_news_list_view.dart';
import 'package:app/widgets/news/saved_news_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsScreen extends ConsumerWidget {
  final bool displaySavedNews;
  const NewsScreen({super.key, this.displaySavedNews = false});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: displaySavedNews
          ? AppBar(title: Text('Saved News Articles'))
          : null,
      body: Scrollbar(
        child: displaySavedNews ? SavedNewsListView() : LatestNewsListView(),
      ),
    );
  }
}
