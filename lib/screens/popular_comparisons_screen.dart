import 'dart:developer';

import 'package:app/exceptions/custom_exception.dart';
import 'package:app/models/device_overview_model.dart';
import 'package:app/providers/controllers/device_controller_provider.dart';
import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:app/repositories/devices_repository.dart';
import 'package:app/screens/comparison_screen.dart';
import 'package:app/utils/dialog_helper.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/general/outlined_expanded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_activity_entry_model.dart';
import '../widgets/popular_comparisons/devices_in_comparison_grid.dart';
import '../widgets/popular_comparisons/popular_comparisons_list_view.dart';

class PopularComparisonsScreen extends ConsumerStatefulWidget {
  const PopularComparisonsScreen({super.key});

  @override
  ConsumerState<PopularComparisonsScreen> createState() =>
      _PopularComparisonsScreenState();
}

class _PopularComparisonsScreenState
    extends ConsumerState<PopularComparisonsScreen> {
  bool _isLoading = false;
  CustomException? _exception;
  List<DeviceOverviewModel>? _comparedDevices;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      _comparedDevices = await ref
          .read(devicesControllerProvider.notifier)
          .getDevices(DeviceType.comparedDevices);
      setState(() => _isLoading = false);
    } on CustomException catch (e) {
      _isLoading = false;
      _exception = e;
      setState(() {});
    }
  }

  void _handleNavigationToComparisonScreen(List<String> comparedDeviceIds) {
    // if only one or none devices are selected for comparison, a dialog is displayed.
    if (comparedDeviceIds.isEmpty) {
      DialogHelper.showWarningDialog(
        context,
        title: 'Not Enough Devices to Compare',
        message:
            'We only allow you to perform comparison when there are more than one device selected for comparison',
      );
      return;
    }
    // navigate to comparison screen
    NavHelper.push(
      context,
      ComparisonScreen(comparedDevices: comparedDeviceIds),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;
    final currComparedDeviceEntries =
        ref.watch(devicesControllerProvider).comparedDevices ??
        List<UserActivityEntryModel>.from([]);
    final currComparedDeviceIds = currComparedDeviceEntries
        .map((e) => e.id)
        .toList();
    final comparedDevices = _comparedDevices
        ?.where((d) => currComparedDeviceIds.contains(d.id))
        .toList();
    log(currComparedDeviceIds.toString());
    log(comparedDevices.toString());

    return Scaffold(
      appBar: AppBar(title: Text('Popular Comparisons')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(12, 15, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Add to Compare'),
            DevicesInComparisonGrid(
              isLoading: _isLoading,
              exception: _exception,
              devicesBeingCompared: comparedDevices,
            ),
            OutlinedExpandedButton(
              margin: const EdgeInsets.fromLTRB(6, 15, 6, 18),
              color: isDarkMode
                  ? Colors.white
                  : theme.appBarTheme.backgroundColor!,
              label: 'go to comparisons',
              icon: Icons.compare_arrows,
              onPressed: () =>
                  _handleNavigationToComparisonScreen(currComparedDeviceIds),
            ),
            _buildTitle('Latest Comparisons'),
            const PopularComparisonListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
    ),
  );
}
