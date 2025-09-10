import 'dart:developer';

import 'package:app/constants/hive_box_names.dart';
import 'package:app/firebase_options.dart';
import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:app/theming/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/controllers/auth_controller_provider.dart';
import 'screens/authentication_screen.dart';
import 'screens/brands_screen.dart';
import 'screens/home_screen.dart';
import 'screens/my_screen.dart';
import 'screens/news_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/wish_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(HiveBoxNames.themeState);
  await Hive.openBox(HiveBoxNames.wishList);
  await Hive.openBox(HiveBoxNames.selectedDevicesForComparison);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final reviews = await GsmarenaRepository().getDeviceReviews(
  //     1,
  //     DeviceOverviewModel(
  //         id: '13706',
  //         name: 'Realme 14 Pro Lite',
  //         imgUrl: 'https://fdn2.gsmarena.com/vv/bigpic/realme-13-pro.jpg',
  //         link: 'realme_14_pro_lite-reviews-13706.php'));
  // log(reviews.reviews.length.toString());
  // final specs = await GsmarenaRepository().getDeviceSpecs(
  //   'apple_iphone_fold_5g-13804.php',
  // );
  // log(specs.toString());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // late StreamSubscription<InternetConnectionStatus> _internetConnection;
  // @override
  // void initState() {
  //   super.initState();

  //   _internetConnection =
  //     +  InternetConnectionChecker().onStatusChange.listen((event) {
  //     print(InternetConnectionChecker().connectionStatus ==
  //         InternetConnectionStatus.connected);
  //     event == InternetConnectionStatus.disconnected
  //         ? showDialog(
  //             context: context, builder: (context) => NoInternetDialog())
  //         : null;
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _internetConnection.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    final appThemeState = ref.watch(themeStateControllerProvider);
    final themeMode = appThemeState.themeMode;
    final isDarkMode = themeMode == ThemeMode.dark;
    log(isDarkMode.toString());
    final appThemes = AppThemes(appThemeState);
    final theme = isDarkMode ? appThemes.darkTheme : appThemes.lightTheme;
    final authenticatedUser = ref.watch(authControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Phone Specs',
      home: authenticatedUser == null
          ? AuthenticationScreen(isSignupMode: false)
          : MyScreen(
              screens: [
                HomeScreen(),
                BrandsScreen(),
                WishListScreen(),
                NewsScreen(),
                SettingsScreen(),
              ],
            ),
      // home: SearchScreen(),
      // home: PopularComparisonsScreen(),
      // home: GeneralSearchScreen(),
      // home: ReviewsAndRatingsScreen(
      //   device: DeviceOverviewModel(
      //     id: '13964',
      //     name: 'Apple iPhone 17 Pro Max',
      //     imgUrl:
      //         'https://fdn2.gsmarena.com/vv/bigpic/apple-iphone-17-pro-max-r.jpg',
      //     link: 'apple_iphone_17_pro_max-13964.php',
      //   ),
      // ),
      // home: AuthenticationScreen(isSignupMode: false),
    );
  }
}
