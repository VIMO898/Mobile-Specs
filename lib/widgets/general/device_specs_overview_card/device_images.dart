import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DeviceImages extends StatefulWidget {
  final double width;
  final double height;
  final List<String> productImgLinks;
  const DeviceImages({
    super.key,
    required this.productImgLinks,
    required this.width,
    required this.height,
  });

  @override
  State<DeviceImages> createState() => _DeviceImagesState();
}

class _DeviceImagesState extends State<DeviceImages> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _handleImgChange(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalImages = widget.productImgLinks.length;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalImages,
              padEnds: true,
              onPageChanged: _handleImgChange,
              itemBuilder: (context, index) {
                final imgSrc = widget.productImgLinks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.network(imgSrc, fit: BoxFit.scaleDown),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 12,
            child: SmoothPageIndicator(
              controller: _pageController,
              onDotClicked: _handleImgChange,
              count: totalImages,
              axisDirection: Axis.horizontal,
              effect: ExpandingDotsEffect(dotWidth: 8, dotHeight: 8),
            ),
          ),
        ],
      ),
    );
  }
}
