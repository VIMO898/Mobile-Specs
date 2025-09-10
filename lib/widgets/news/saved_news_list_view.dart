import 'package:app/exceptions/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/controllers/saved_news_controller_provider.dart';
import '../../screens/news_details_screen.dart';
import '../../utils/nav_helper.dart';
import '../general/no_data_message.dart';
import 'news_card.dart';

class SavedNewsListView extends ConsumerWidget {
  const SavedNewsListView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return StreamBuilder(
      stream: ref
          .read(savedNewsControllerProvider.notifier)
          .getSavedNewsArticleStream(),
      builder: (context, asyncSnapshot) {
        // error
        if (asyncSnapshot.hasError) {
          final error = asyncSnapshot.error as CustomException;
          return NoDataMessage(
            icon: Icons.error_outline,
            title: error.code ?? 'Something went wrong',
            subtitle: error.message,
          );
        }
        // loading
        final isStreanLoading =
            asyncSnapshot.connectionState == ConnectionState.waiting;
        final savedNewsListFuture = asyncSnapshot.data;
        return FutureBuilder(
          future: savedNewsListFuture,
          builder: (context, snapshot) {
            // error
            if (snapshot.hasError) {
              final error = snapshot.error as CustomException;
              return NoDataMessage(
                icon: Icons.error_outline,
                title: error.code ?? 'Something went wrong',
                subtitle: error.message,
              );
            }
            // loading
            final isFutureLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final data = snapshot.data;
            // empty message
            if (data?.isEmpty ?? false) {
              return NoDataMessage(
                icon: Icons.newspaper_outlined,
                title: 'Empty List',
                subtitle: 'Please save news articles to see them here',
              );
            }
            return ListView.builder(
              itemCount: data?.length ?? 10,
              itemBuilder: (context, index) {
                final currNews = data?[index];
                return NewsCard(
                  isStreanLoading || isFutureLoading,
                  currNews?.overview,
                  () => NavHelper.push(
                    context,
                    NewsDetailsScreen(
                      newsOverview: currNews!.overview,
                      newsDetails: currNews.details,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
