import 'package:app/exceptions/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories/gsmarena_repo_provider.dart';
import '../../screens/news_details_screen.dart';
import '../../utils/nav_helper.dart';
import '../general/no_data_message.dart';
import 'news_card.dart';

class LatestNewsListView extends ConsumerWidget {
  const LatestNewsListView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return FutureBuilder(
      future: ref.read(gsmarenRepoProvider).getTechNews(),
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        if (snapshot.hasError) {
          final exception = snapshot.error as CustomException;
          return NoDataMessage(
            icon: Icons.newspaper,
            title: exception.code ?? 'Unable to load',
            subtitle: exception.message,
          );
        }
        final data = snapshot.data;
        return ListView.builder(
          itemCount: data?.length ?? 10,
          itemBuilder: (context, index) {
            final currNews = data?[index];
            return NewsCard(
              isLoading,
              currNews,
              () => NavHelper.push(
                context,
                NewsDetailsScreen(newsOverview: currNews!, newsDetails: null),
              ),
            );
          },
        );
      },
    );
  }
}
