import 'package:app/exceptions/custom_exception.dart';
import 'package:app/models/news_model.dart';
import 'package:app/models/news_overview_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/controllers/saved_news_controller_provider.dart';
import '../providers/repositories/gsmarena_repo_provider.dart';
import '../utils/nav_helper.dart';
import '../widgets/general/no_data_message.dart';
import '../widgets/news/news_card.dart';
import 'news_details_screen.dart';

class NewsScreen extends ConsumerStatefulWidget {
  final bool displaySavedNews;
  const NewsScreen({super.key, this.displaySavedNews = false});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  bool _isLoading = false;
  List<Object>? _data;
  CustomException? _exception;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _exception = null;
      _isLoading = true;
      setState(() {});
      if (widget.displaySavedNews) {
        _data = await ref
            .read(savedNewsControllerProvider.notifier)
            .getSavedNewsArticles();
      } else {
        _data = await ref.read(gsmarenRepoProvider).getTechNews();
      }
      setState(() => _isLoading = false);
    } on CustomException catch (e) {
      _isLoading = false;
      _exception = e;
      setState(() {});
    }
  }

  void _toggleSavedNewsArticle(NewsModel news, bool newsArticleSaved) {
    final data = List<NewsModel>.from(_data!);
    if (newsArticleSaved) {
      _data = data.where((n) => n.overview.id != news.overview.id).toList();
    } else {
      _data = [news, ...data];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final savedNewsDisplayed = widget.displaySavedNews;
    return Scaffold(
      appBar: widget.displaySavedNews
          ? AppBar(title: Text('Saved News Articles'))
          : null,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _exception != null
            ? NoDataMessage(
                icon: Icons.newspaper,
                title: _exception!.code ?? 'Unable to load',
                subtitle: _exception!.message,
                onRefresh: _loadData,
              )
            : (_data?.isEmpty ?? false)
            ? NoDataMessage(
                icon: Icons.newspaper_outlined,
                title: 'Empty List',
                subtitle: 'Please save news articles to see them here',
              )
            : Scrollbar(
                child: ListView.builder(
                  itemCount: _data?.length ?? 10,
                  itemBuilder: (context, index) {
                    final currNews = _data?[index];
                    final newsOverview = savedNewsDisplayed
                        ? (currNews as NewsModel?)?.overview
                        : currNews as NewsOverviewModel?;
                    final newsDetails = savedNewsDisplayed
                        ? (currNews as NewsModel?)?.details
                        : null;
                    return NewsCard(
                      _isLoading,
                      newsOverview,
                      () => NavHelper.push(
                        context,
                        NewsDetailsScreen(
                          newsOverview: newsOverview!,
                          newsDetails: newsDetails,
                          onToggleNewsArticleSave: savedNewsDisplayed
                              ? (saved) => _toggleSavedNewsArticle(
                                  NewsModel(
                                    overview: newsOverview,
                                    details: newsDetails!,
                                  ),
                                  saved,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
