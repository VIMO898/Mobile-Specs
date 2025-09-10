import 'package:app/exceptions/custom_exception.dart';
import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/screens/search_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:app/widgets/search/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_overview_model.dart';
import '../widgets/search/recently_viewed_devices.dart';
import '../widgets/search/trending_searches.dart';

class GeneralSearchScreen extends ConsumerStatefulWidget {
  const GeneralSearchScreen({super.key});

  @override
  ConsumerState<GeneralSearchScreen> createState() =>
      _GeneralSearchScreenState();
}

class _GeneralSearchScreenState extends ConsumerState<GeneralSearchScreen> {
  bool _isLoading = false;
  String? _error;
  List<DeviceOverviewModel> _trendingDevices = [];
  @override
  void initState() {
    super.initState();
    _getTrendingDevices();
  }

  Future<void> _getTrendingDevices() async {
    try {
      setState(() => _isLoading = true);
      _trendingDevices = await ref
          .read(gsmarenRepoProvider)
          .getAllSearchedDevicesOverview('');
      setState(() => _isLoading = false);
    } on CustomException catch (_) {
      _isLoading = false;
      _error = 'Something went wrong!';
      setState(() {});
    }
  }

  void _navigateToSearchScreen(BuildContext context) {
    NavHelper.push(context, SearchScreen(trendingDevices: _trendingDevices));
  }

  @override
  Widget build(BuildContext context) {
    // final wishlistedDevices = ref.watch(deviceOverviewControllerProvider);
    // final selectedDevicesForComparison =
    //     ref.watch(deviceComparisonControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('General Search'), centerTitle: true),
      body: Column(
        children: [
          SearchField(
            readOnly: true,
            onTap: () => _navigateToSearchScreen(context),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                ? NoDataMessage(
                    title: "Couldn't load data",
                    subtitle:
                        'Please make sure you have your internet connection working properly',
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        TrendingSearches(_trendingDevices),
                        DeviceHorizontalListView(
                          title: 'Recently Viewed',
                          devices: [
                            DeviceOverviewModel(
                              id: '',
                              link: '',
                              name: 'Motorola Defy 2',
                              imgUrl:
                                  'https://fdn2.gsmarena.com/vv/bigpic/motorola-defy-2-new.jpg',
                            ),
                          ],
                          button: TextButton(
                            onPressed: () {},
                            child: Text('View All'),
                          ),
                        ),
                        // DeviceHorizontalListView(
                        //   title: 'Selected For Comparison',
                        //   devices: selectedDevicesForComparison,
                        //   button: TextButton(
                        //       onPressed: () {}, child: Text('View All')),
                        // ),
                        // DeviceHorizontalListView(
                        //   title: 'Wishlist',
                        //   devices: wishlistedDevices,
                        //   button: TextButton(
                        //       onPressed: () {}, child: Text('View All')),
                        // ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
