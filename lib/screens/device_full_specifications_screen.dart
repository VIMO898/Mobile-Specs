import 'dart:developer';

import 'package:app/models/device_overview_model.dart';
import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/skeletons/screens/device_full_specifications_screen_skeleton.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/full_specifications/device_full_specs_list_view.dart';
import '../widgets/full_specifications/device_specs_card.dart';

class DeviceFullSpecificationsScreen extends ConsumerWidget {
  final DeviceOverviewModel deviceOverview;
  const DeviceFullSpecificationsScreen(this.deviceOverview, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Specifications')),
      body: FutureBuilder(
        future: ref
            .read(gsmarenRepoProvider)
            .getDeviceSpecs(deviceOverview.link),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DeviceFullSpecificationsScreenSkeleton();
          }
          if (snapshot.hasError || snapshot.data == null) {
            log(snapshot.error.toString());
            return const NoDataMessage(
              title: "Unable to Get Device's Specifications",
              subtitle:
                  "This error likely occurred due to your internect connection.\nMake sure your internet's working.",
            );
          }
          final specs = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Column(
              children: [
                DeviceSpecsCard(
                  deviceOverview: deviceOverview,
                  deviceSpecs: specs,
                ),
                const SizedBox(height: 10),
                DeviceFullSpecsListView(specs),
              ],
            ),
          );
        },
      ),
    );
  }
}
