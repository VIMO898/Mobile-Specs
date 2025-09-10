import 'dart:developer';

import 'package:app/models/device_overview_model.dart';
import 'package:app/models/review_model.dart';
import 'package:app/models/review_with_user_info_model.dart';
import 'package:app/providers/controllers/auth_controller_provider.dart';
import 'package:app/providers/repositories/reviews_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../exceptions/custom_exception.dart';
import '../../utils/snack_bar_helper.dart';

class WriteReview extends ConsumerStatefulWidget {
  final DeviceOverviewModel deviceOverview;
  final ReviewModel? submittedReview;
  final void Function(ReviewWithUserInfoModel review)?
  onSuccessfulReviewSubmission;
  const WriteReview({
    super.key,
    this.submittedReview,
    required this.deviceOverview,
    this.onSuccessfulReviewSubmission,
  });

  @override
  ConsumerState<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends ConsumerState<WriteReview> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  late final TextEditingController _textEditingController;
  late final ExpansibleController _expansibleController;
  bool _reviewBeingSubmitted = false;
  @override
  void initState() {
    super.initState();
    _rating = widget.submittedReview?.ratings ?? 0;
    _expansibleController = ExpansibleController();
    _expansibleController.addListener(_handleExpansibleChange);
    _textEditingController = TextEditingController();
    _textEditingController.text = widget.submittedReview?.review ?? '';
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _expansibleController.removeListener(_handleExpansibleChange);
    _expansibleController.dispose();
    super.dispose();
  }

  void _handleExpansibleChange() {
    _rating = widget.submittedReview?.ratings ?? 0;
    _textEditingController.text = widget.submittedReview?.review ?? '';
    log(_expansibleController.isExpanded.toString());
    setState(() {});
  }

  String? _validateReviewField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Review cannot be empty';
    }
    if (value.trim().length < 4) {
      return 'Review must be at least 4 characters';
    }
    return null;
  }

  Future<void> _handleReviewSubmission() async {
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid || _reviewBeingSubmitted) return;
    try {
      setState(() => _reviewBeingSubmitted = true);
      final now = DateTime.now();
      final reviewedAt = now.millisecondsSinceEpoch;
      final review = ReviewModel(
        review: _textEditingController.text,
        ratings: _rating,
        reviewedAt: reviewedAt,
      );
      await ref
          .read(reviewsRepositoryProvider)
          .submitReview(widget.deviceOverview, review);

      final userInfo = await ref
          .read(authControllerProvider.notifier)
          .getUserInfo();
      if (widget.onSuccessfulReviewSubmission != null) {
        final reviewWithUserInfo = ReviewWithUserInfoModel(
          review: review,
          userInfo: userInfo!,
        );
        widget.onSuccessfulReviewSubmission!(reviewWithUserInfo);
      }
      setState(() => _reviewBeingSubmitted = false);
      _expansibleController.collapse();
    } on CustomException catch (e) {
      setState(() => _reviewBeingSubmitted = false);
      SnackBarHelper.show(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUserAlreadySubmittedReview = widget.submittedReview != null;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        child: ExpansionTile(
          controller: _expansibleController,
          title: Text(
            '${hasUserAlreadySubmittedReview ? "Edit" : "WRITE"} A REVIEW',
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 12),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          backgroundColor: theme.scaffoldBackgroundColor,
          collapsedBackgroundColor: theme.cardColor,
          children: [
            const Divider(height: 0),
            const SizedBox(height: 8),
            Text('Your rating', style: textTheme.bodyLarge),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () => setState(() => _rating = index + 1),
                    child: Icon(
                      _rating > index ? Icons.star : Icons.star_outline,
                      size: 40,
                      color: _rating > index
                          ? theme.appBarTheme.backgroundColor
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            Text('Your Comments', style: textTheme.bodyLarge),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: TextFormField(
                  controller: _textEditingController,
                  minLines: 3,
                  maxLines: 6,
                  validator: _validateReviewField,
                  decoration: InputDecoration(
                    hintText: 'Write your opinions on this device...',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.all(12),
                    border: const UnderlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.cardColor,
                    filled: true,
                  ),
                ),
              ),
            ),
            // ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton.icon(
                onPressed: _handleReviewSubmission,
                style: ElevatedButton.styleFrom(
                  shape: _reviewBeingSubmitted
                      ? CircleBorder()
                      : RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  backgroundColor: theme.appBarTheme.backgroundColor,
                ),
                icon: !_reviewBeingSubmitted
                    ? Icon(Icons.send, color: Colors.white)
                    : SizedBox.shrink(),
                label: _reviewBeingSubmitted
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        hasUserAlreadySubmittedReview ? 'Edit' : 'SUBMIT',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       margin: const EdgeInsets.only(top: 12, bottom: 16),
//       color: Colors.grey.shade300,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // const Divider(height: 0),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('WRITE A REVIEW'),
//                   GestureDetector(
//                       onTap: () {}, child: const Icon(Icons.expand_more)),
//                 ]),
//           ),
//           const Divider(height: 0),
//           const SizedBox(height: 8),
//           const Text(
//             'Your rating',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//           ),
//           Padding(
//               padding: const EdgeInsets.only(top: 14, bottom: 10),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: List.generate(
//                       5,
//                       (index) => GestureDetector(
//                             onTap: () => setState(() => _rating = index + 1),
//                             child: Icon(
//                               _rating > index ? Icons.star : Icons.star_outline,
//                               size: 40,
//                               color: _rating > index
//                                   ? widget.theme.appBarTheme.backgroundColor
//                                   : null,
//                             ),
//                           )))),
//           const Text('Your Comments',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 7),
//             child: TextField(
//               minLines: 3,
//               maxLines: 6,
//               decoration: InputDecoration(
//                   hintText: 'Write your opinions on this devices',
//                   floatingLabelBehavior: FloatingLabelBehavior.never,
//                   contentPadding: const EdgeInsets.all(12),
//                   border: const UnderlineInputBorder(
//                       borderRadius: BorderRadius.zero,
//                       borderSide: BorderSide.none),
//                   fillColor: widget.theme.primaryColor,
//                   filled: true),
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Container(
//                 width: 112,
//                 decoration: BoxDecoration(
//                     color: widget.theme.appBarTheme.backgroundColor),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Icon(
//                       Icons.send,
//                       size: 18,
//                       color: Colors.white,
//                     ),
//                     Text(
//                       'SUBMIT',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 )),
//           ),
//           const Divider(height: 20),
//         ],
//       ),
//     )