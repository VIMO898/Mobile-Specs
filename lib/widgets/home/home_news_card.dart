import 'package:app/skeletons/widgets/home/home_news_card_skeleton.dart';
import 'package:flutter/material.dart';

import '../../models/news_overview_model.dart';

class HomeNewsCard extends StatelessWidget {
  const HomeNewsCard({
    super.key,
    this.isLoading = false,
    required this.news,
    required this.onTap,
  });
  final bool isLoading;
  final NewsOverviewModel? news;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return isLoading
        ? HomeNewsCardSkeleton()
        : GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.topLeft,
              width: 160,
              height: double.infinity,
              margin: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    child: Image.network(
                      news!.imgUrl,
                      fit: BoxFit.fitHeight,
                      height: 95,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      news!.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
