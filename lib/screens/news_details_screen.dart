import 'dart:developer';

import 'package:app/exceptions/custom_exception.dart';
import 'package:app/models/detailed_news_model.dart';
import 'package:app/models/news_model.dart';
import 'package:app/models/news_overview_model.dart';
import 'package:app/providers/controllers/saved_news_controller_provider.dart';
import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/utils/snack_bar_helper.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../skeletons/screens/news_details_screen_skeleton.dart';

class NewsDetailsScreen extends ConsumerStatefulWidget {
  final NewsOverviewModel newsOverview;
  final DetailedNewsModel? newsDetails;
  final void Function(bool saved)? onToggleNewsArticleSave;
  const NewsDetailsScreen({
    super.key,
    required this.newsOverview,
    this.newsDetails,
    this.onToggleNewsArticleSave,
  });

  @override
  ConsumerState<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends ConsumerState<NewsDetailsScreen> {
  bool _isLoading = false;
  bool _newsSaveToggleLoading = false;
  CustomException? _exception;
  DetailedNewsModel? _detailedNews;
  @override
  void initState() {
    super.initState();
    if (widget.newsDetails != null) {
      // already have news details
      _detailedNews = widget.newsDetails;
    } else {
      // load news details from GSMArena
      _loadDetailedNews();
    }
  }

  Future<void> _loadDetailedNews() async {
    try {
      _exception = null;
      setState(() => _isLoading = true);
      _detailedNews = await ref
          .read(gsmarenRepoProvider)
          .getDetailedNews(widget.newsOverview.link);
      setState(() => _isLoading = false);
    } on CustomException catch (e) {
      _isLoading = false;
      _exception = e;
      setState(() {});
    }
  }

  Future<void> _handleNewsSaveToggle(bool isCurrNewsSaved) async {
    setState(() => _newsSaveToggleLoading = true);
    try {
      if (!isCurrNewsSaved) {
        await ref
            .read(savedNewsControllerProvider.notifier)
            .saveNewsArticle(
              NewsModel(overview: widget.newsOverview, details: _detailedNews!),
            );
        if (widget.onToggleNewsArticleSave != null) {
          widget.onToggleNewsArticleSave!(false);
        }
      } else {
        final newsId = widget.newsOverview.id;
        await ref
            .read(savedNewsControllerProvider.notifier)
            .removeNewsArticle(newsId);
        if (widget.onToggleNewsArticleSave != null) {
          widget.onToggleNewsArticleSave!(true);
        }
      }
      setState(() => _newsSaveToggleLoading = false);
    } on CustomException {
      setState(() => _newsSaveToggleLoading = false);
      SnackBarHelper.show(
        context,
        'Unable to perform this action at this moment. Please try again!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final title = widget.newsOverview.title;
    final imgUrl = widget.newsOverview.imgUrl;
    final writtenBy = _detailedNews?.reviewer;
    final description = _detailedNews?.description;
    final savedNewsArticleEntries = ref.watch(savedNewsControllerProvider);
    final newsId = widget.newsOverview.id;
    final isCurrNewsSaved = savedNewsArticleEntries.any((n) => n.id == newsId);
    log(savedNewsArticleEntries.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
        actions: [
          if (_detailedNews != null && !_newsSaveToggleLoading)
            IconButton(
              onPressed: () => _handleNewsSaveToggle(isCurrNewsSaved),
              icon: Icon(
                isCurrNewsSaved
                    ? Icons.download_done_outlined
                    : Icons.download_outlined,
              ),
            ),
          if (_newsSaveToggleLoading)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: theme.textTheme.bodyLarge!.color,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDetailedNews,
        child: _isLoading
            ? const NewsDetailsScreenSkeleton()
            : _exception != null
            ? NoDataMessage(
                title: 'Having Trouble',
                subtitle:
                    'To load the details of this news. Please check your internet connection',
                onRefresh: _loadDetailedNews,
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNetworkImg(
                        url: imgUrl,
                        padding: const EdgeInsets.only(bottom: 6),
                      ),
                      Text(
                        title,
                        style: textTheme.titleLarge?.copyWith(
                          // fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        writtenBy!,
                        style: TextStyle(
                          // color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(description!, style: textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildNetworkImg({
    required String url,
    EdgeInsets? padding,
    double? size,
  }) => Padding(
    padding: padding ?? EdgeInsets.zero,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: size,
      ),
    ),
  );
}
