// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app/models/device_feature_model.dart';
import 'package:app/models/device_overview_model.dart';

class DevicesComparisonModel {
  final List<DeviceOverviewModel> overviews;
  final List<DeviceFeatureModel> features;
  const DevicesComparisonModel(
      {required this.overviews, required this.features});

  @override
  String toString() =>
      'DevicesComparisonModel(overviews: $overviews, features: $features)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'overviews': overviews.map((x) => x.toMap()).toList(),
      'features': features.map((x) => x.toMap()).toList(),
    };
  }

  factory DevicesComparisonModel.fromMap(Map<String, dynamic> map) {
    return DevicesComparisonModel(
      overviews: List<DeviceOverviewModel>.from((map['overviews'] as List<int>)
          .map<DeviceOverviewModel>(
              (x) => DeviceOverviewModel.fromMap(x as Map<String, dynamic>))),
      features: List<DeviceFeatureModel>.from((map['features'] as List<int>)
          .map<DeviceFeatureModel>(
              (x) => DeviceFeatureModel.fromMap(x as Map<String, dynamic>))),
    );
  }

  String toJson() => json.encode(toMap());

  factory DevicesComparisonModel.fromJson(String source) =>
      DevicesComparisonModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
