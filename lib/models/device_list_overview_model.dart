import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DeviceDetailedOverviewModel {
  final String name;
  final String price;
  final String launchDate;
  final List<String> images;
  final String? processor;
  final String? rearCam;
  final String? frontCam;
  final String? display;
  final String? ramStorage;
  final String? battery;
  final String? software;
  final String? hardware;
  DeviceDetailedOverviewModel({
    required this.name,
    required this.price,
    required this.launchDate,
    required this.images,
    required this.processor,
    required this.rearCam,
    required this.frontCam,
    required this.display,
    required this.ramStorage,
    required this.battery,
    required this.software,
    required this.hardware,
  });

  @override
  String toString() {
    return 'DeviceListOverviewModel(name: $name, price: $price, launchDate: $launchDate, images: $images, processor: $processor, rearCam: $rearCam, frontCam: $frontCam, display: $display, ramStorage: $ramStorage, battery: $battery, software: $software, hardware: $hardware)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'launchDate': launchDate,
      'images': images,
      'processor': processor,
      'rearCam': rearCam,
      'frontCam': frontCam,
      'display': display,
      'ramStorage': ramStorage,
      'battery': battery,
      'software': software,
      'hardware': hardware,
    };
  }

  factory DeviceDetailedOverviewModel.fromMap(Map<String, dynamic> map) {
    return DeviceDetailedOverviewModel(
      name: map['name'] as String,
      price: map['price'] as String,
      launchDate: map['launchDate'] as String,
      images: List<String>.from((map['images'] as List<String>)),
      processor: map['processor'] != null ? map['processor'] as String : null,
      rearCam: map['rearCam'] != null ? map['rearCam'] as String : null,
      frontCam: map['frontCam'] != null ? map['frontCam'] as String : null,
      display: map['display'] != null ? map['display'] as String : null,
      ramStorage:
          map['ramStorage'] != null ? map['ramStorage'] as String : null,
      battery: map['battery'] != null ? map['battery'] as String : null,
      software: map['software'] != null ? map['software'] as String : null,
      hardware: map['hardware'] != null ? map['hardware'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceDetailedOverviewModel.fromJson(String source) =>
      DeviceDetailedOverviewModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
