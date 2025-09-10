// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app/models/specs_model.dart';

class DeviceFeatureModel {
  final String name;
  final List<SpecsModel> specs;
  const DeviceFeatureModel({
    required this.name,
    required this.specs,
  });

  @override
  String toString() => 'DeviceFeatureModel(name: $name, specs: $specs)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'specs': specs.map((x) => x.toMap()).toList(),
    };
  }

  factory DeviceFeatureModel.fromMap(Map<String, dynamic> map) {
    return DeviceFeatureModel(
      name: map['name'] as String,
      specs: List<SpecsModel>.from(
        (map['specs'] as List<int>).map<SpecsModel>(
          (x) => SpecsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceFeatureModel.fromJson(String source) =>
      DeviceFeatureModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
