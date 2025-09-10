import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RegionCurrencyModel {
  final String name;
  final String currencySymbol;
  final double value;
  const RegionCurrencyModel({
    required this.name,
    required this.currencySymbol,
    required this.value,
  });

  @override
  String toString() =>
      'RegionCurrencyModel(name: $name, currencySymbol: $currencySymbol, value: $value)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'currencySymbol': currencySymbol,
      'value': value,
    };
  }

  factory RegionCurrencyModel.fromMap(Map<String, dynamic> map) {
    return RegionCurrencyModel(
      name: map['name'] as String,
      currencySymbol: map['currencySymbol'] as String,
      value: map['value'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegionCurrencyModel.fromJson(String source) =>
      RegionCurrencyModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
