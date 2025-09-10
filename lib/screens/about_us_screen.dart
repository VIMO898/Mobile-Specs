import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'info_screen.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return const InfoScreen(
        screenName: 'About us',
        textSpan: TextSpan(
            text:
                'MobPrice believes the right of our customers who deserve the correct information before purchasing products. Falsifying and misleading information can make negative impact on the perspective of customers. That\'s where we come in. It\'s is great medium for users to gain correct information for products, decision making, purchase products.\n\nThe difference between our app and others are, we\'re covering global mobile information as well as local. We do not simply convert the price. The prices are updated in accordance with local market. This is also correct for specification variations. Latest news are available too. As a result users can access their desirable product information without hassle morover, the official source of the product is also available.\n\nThis site contains expert score of mobiles which will help users to view on expert opinion. Users can compare mobiles at their own\npreference. Customized filtering option can narrow the search as user\'s preference. Variations of brands can guarantee all kinds of preferable mobile\'s availability. Our future plan is much broader. In future users will get various offers. Purchasing procedure will also be included.\n\nWe are a team committed to serve you better everyday. It\'s our reposibility and promise to serve you with best information and other services.'));
  }
}
