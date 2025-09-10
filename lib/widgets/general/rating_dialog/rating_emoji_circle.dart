import 'package:flutter/material.dart';

class RatingEmojiInCircle extends StatelessWidget {
  final int rating;
  const RatingEmojiInCircle({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 115,
      height: 115,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            offset: const Offset(1, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Image.asset(
        getRatingEmojiAssetImgUrl(rating),
        fit: BoxFit.contain,
      ),
    );
  }
}

String getRatingEmojiAssetImgUrl(int rating) {
  const baseUrl = 'assets/images/rating_emojis';
  switch (rating) {
    case 1:
      return "$baseUrl/one-star.png";
    case 2:
      return "$baseUrl/two-star.png";
    case 3:
      return "$baseUrl/three-star.png";
    case 4:
      return "$baseUrl/four-star.png";
    case 5:
      return "$baseUrl/five-star.png";
    default:
      return "$baseUrl/five-star.png";
  }
}
