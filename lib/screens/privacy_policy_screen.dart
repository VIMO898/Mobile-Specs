import 'package:flutter/material.dart';

import 'info_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final headingTextStyle = textTheme.titleLarge;
    return InfoScreen(
      screenName: 'Privacy Policy',
      textSpan: TextSpan(
        children: [
          TextSpan(
            text: 'Last Updated: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: 'Nov 14, 2023 \n\n'),
          TextSpan(
            text:
                'We value your privacy very highly. Please read this Privacy Policy carefully before using the MobPrice.net Website, operated by Innolytic IT LTD formed in Dhaka, Bangladesh. In this privacy policy by the term “we, our, us, mobprice indicates to MobPrice .net. By the term "you", "user" indicates to all clients, merchants or visitors. In our mission to make your searching easily to find the right mobile at MobPrice, we collect and use information about you.This Privacy Policy will help you better understand how we collect, use, and share your personal information. If we change our privacy practices, we may update this privacy policy. If any changes are significant, we will let you know by Email. You accept and agree to this Privacy Policy and your access to and use of the Website is conditional. This Privacy Policy applies to everyone, including but not limited to, visitors, users and others who wish to access or use the Website. By accessing or using the Website, you agree to be bound by this Privacy Policy.\n\n',
          ),
          TextSpan(
            text: 'Kind of information we collect\n',
            style: headingTextStyle,
          ),
          TextSpan(
            text:
                '1. Your name, address, e - mail address, mobile number and any other physical contact information.\n2. After the required information is conveyed to us the user is no longer anonymous to MobPrice.\n3. Any other additional information we may ask you to submit for your authentication or if we believe you are violating your site policy with information related to your ID or bill to answer additional questions online to help verify your address or help verify your identity For.\n\n',
          ),
          TextSpan(
            text: 'Our use of your information\n',
            style: headingTextStyle,
          ),
          TextSpan(
            text:
                'The information provided by You at the time of registration shall be used to contact You when necessary. These necessary conditions include:\n\n',
          ),
          TextSpan(
            text:
                '1. Identify you and manage your favorite list\n2. To inform about a possible data breach\n3. To inform about shut down of the application or its services\n\n',
          ),
          TextSpan(
            text:
                'Your data will not be shared with any third parties unless in case company gets acquired/merged, in which case, You will be notified by email/ by putting a prominent notice on the Website, before there is a data transfer to the new entity and becomes subject to a different privacy policy.\nFurther, Your personal data and Sensitive Personal Information may be collected and stored by Us for internal record. All such data is encrypted before storing. All such data is transmitted securely.\n\n',
          ),
          TextSpan(text: 'Confidentiality\n', style: headingTextStyle),
          TextSpan(
            text:
                'We shall not sell, share, or rent your Personal data such as, Your name Your Phone Number and Your e-mail address to any third party or use your e-mail address for unsolicited mail. We may share other information we track such as Your web browsing history or tracking information with Third Parties.\n\n',
          ),
          TextSpan(text: 'Cookie\n', style: headingTextStyle),
          TextSpan(
            text:
                'We use cookies on our website to give you the most relevant experience by remembering your preferences and repeat visits.\n\n',
          ),
          TextSpan(
            text: 'Changes to Privacy Policy\n',
            style: headingTextStyle,
          ),
          TextSpan(
            text:
                'We reserve the right to amend this Privacy Policy at any time. We will notify you of any changes to this Privacy Policy by posting the updated privacy policy to this website.\n\n',
          ),
          TextSpan(text: 'How you can reach us\n', style: headingTextStyle),
          TextSpan(
            text:
                'flat 4a, 3/3 block E, Lalmatia\nDhaka - 1207\nEmail: contact@mobprice.net\nMobile No: +880 1610 853 744\n',
          ),
        ],
      ),
    );
  }
}
