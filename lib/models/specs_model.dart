import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SpecsModel {
  final String name;
  final List<String> values;
  const SpecsModel({
    required this.name,
    required this.values,
  });

  @override
  String toString() => 'SpecsModel(name: $name, values: $values)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'values': values,
    };
  }

  factory SpecsModel.fromMap(Map<String, dynamic> map) {
    return SpecsModel(
      name: map['name'] as String,
      values: List<String>.from((map['values'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory SpecsModel.fromJson(String source) =>
      SpecsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
