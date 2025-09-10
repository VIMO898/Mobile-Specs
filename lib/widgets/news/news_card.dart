import 'package:app/models/news_overview_model.dart';
import 'package:app/skeletons/widgets/news/news_card_skeleton.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final NewsOverviewModel? newsOverview;
  final bool isLoading;
  final VoidCallback onTap;
  const NewsCard(this.isLoading, this.newsOverview, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return isLoading
        ? NewsCardSkeleton()
        : GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 355,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      newsOverview!.imgUrl,
                      fit: BoxFit.cover,
                      height: 195,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    newsOverview!.title,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    newsOverview!.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          );
  }
}
