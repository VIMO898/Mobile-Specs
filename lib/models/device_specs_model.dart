// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app/models/device_feature_model.dart';
import 'package:app/models/device_overview_model.dart';

class DeviceSpecsModel {
  final DeviceOverviewModel overview;
  final List<DeviceFeatureModel> features;
  const DeviceSpecsModel({required this.overview, required this.features});

  @override
  String toString() =>
      'DeviceSpecsModel(overview: $overview, features: $features)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'overview': overview.toMap(),
      'features': features.map((x) => x.toMap()).toList(),
    };
  }

  factory DeviceSpecsModel.fromMap(Map<String, dynamic> map) {
    return DeviceSpecsModel(
      overview:
          DeviceOverviewModel.fromMap(map['overview'] as Map<String, dynamic>),
      features: List<DeviceFeatureModel>.from(
        (map['features'] as List<int>).map<DeviceFeatureModel>(
          (x) => DeviceFeatureModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceSpecsModel.fromJson(String source) =>
      DeviceSpecsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
