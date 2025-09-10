import 'package:flutter/material.dart';

class StarProgressBar extends StatelessWidget {
  const StarProgressBar({
    super.key,
    required this.color,
    required this.fullWidth,
    required this.progressWidth,
    required this.star,
  });

  final Color color;
  final double fullWidth;
  final double progressWidth;
  final int star;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth,
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          const Icon(Icons.star),
          Text(
            star.toString(),
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color.withValues(alpha: 0.3),
              ),
              height: 10,
              child: Row(
                children: [
                  Container(
                    width: progressWidth * 0.7,
                    color: color,
                    height: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
