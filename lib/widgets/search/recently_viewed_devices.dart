import 'package:app/models/device_overview_model.dart';
import 'package:flutter/material.dart';

import '../general/device_card.dart';

class DeviceHorizontalListView extends StatelessWidget {
  final String? title;
  final Widget? button;
  final List<DeviceOverviewModel> devices;
  const DeviceHorizontalListView(
      {super.key, this.title, this.button, required this.devices});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(fontSize: 20),
                ),
              if (button != null) button!,
            ],
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return DeviceCard(
                  margin: const EdgeInsets.only(right: 10),
                  width: 160,
                  deviceOverview: device,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
