import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TwoDeviceComparisonModel {
  final String firstDeviceId;
  final String lastDeviceId;
  final String firstDeviceName;
  final String lastDeviceName;
  TwoDeviceComparisonModel({
    required this.firstDeviceId,
    required this.lastDeviceId,
    required this.firstDeviceName,
    required this.lastDeviceName,
  });

  @override
  String toString() {
    return 'TwoDeviceComparisonModel(firstDeviceId: $firstDeviceId, lastDeviceId: $lastDeviceId, firstDeviceName: $firstDeviceName, lastDeviceName: $lastDeviceName)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstDeviceId': firstDeviceId,
      'lastDeviceId': lastDeviceId,
      'firstDeviceName': firstDeviceName,
      'lastDeviceName': lastDeviceName,
    };
  }

  factory TwoDeviceComparisonModel.fromMap(Map<String, dynamic> map) {
    return TwoDeviceComparisonModel(
      firstDeviceId: map['firstDeviceId'] as String,
      lastDeviceId: map['lastDeviceId'] as String,
      firstDeviceName: map['firstDeviceName'] as String,
      lastDeviceName: map['lastDeviceName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TwoDeviceComparisonModel.fromJson(String source) =>
      TwoDeviceComparisonModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
