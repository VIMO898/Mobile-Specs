import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/news_overview_model.dart';
import '../../providers/repositories/gsmarena_repo_provider.dart';
import '../../providers/general/curr_tab_index_provider.dart';
import '../../screens/news_details_screen.dart';
import '../../utils/nav_helper.dart';
import 'home_news_card.dart';

class LatestNewsListViewBuilder extends ConsumerWidget {
  const LatestNewsListViewBuilder({super.key});

  void _navigateToNewsDetailScreen(
    BuildContext context,
    NewsOverviewModel newsOverview,
  ) {
    NavHelper.push(context, NewsDetailsScreen(newsOverview: newsOverview));
  }

  void _handleHomeTabIndexChange(WidgetRef ref, int index) {
    ref.read(currTabIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final newsOverviewFuture = ref.read(gsmarenRepoProvider).getTechNews();
    return Container(
      height: 230,
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 17, 6, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latest News',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () => _handleHomeTabIndexChange(ref, 3),
                  child: Text(
                    'VIEW ALL',
                    style: textTheme.labelSmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: newsOverviewFuture,
              builder: (context, snapshot) {
                final isLoading =
                    snapshot.connectionState == ConnectionState.waiting;
                final news = snapshot.data;
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: news?.length,
                  itemBuilder: (context, index) {
                    final currNews = news?[index];
                    return HomeNewsCard(
                      isLoading: isLoading,
                      news: currNews,
                      onTap: () =>
                          _navigateToNewsDetailScreen(context, currNews!),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
