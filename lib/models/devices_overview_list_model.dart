// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'device_overview_model.dart';

class DevicesOverviewListModel {
  final List<DeviceOverviewModel> devices;
  final int totalPages;
  const DevicesOverviewListModel(
      {required this.devices, required this.totalPages});

  @override
  String toString() =>
      'DevicesOverviewListModel(devices: $devices, totalPages: $totalPages)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'devices': devices.map((x) => x.toMap()).toList(),
      'totalPages': totalPages,
    };
  }

  factory DevicesOverviewListModel.fromMap(Map<String, dynamic> map) {
    return DevicesOverviewListModel(
      devices: List<DeviceOverviewModel>.from(
        (map['devices'] as List<int>).map<DeviceOverviewModel>(
          (x) => DeviceOverviewModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalPages: map['totalPages'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DevicesOverviewListModel.fromJson(String source) =>
      DevicesOverviewListModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
