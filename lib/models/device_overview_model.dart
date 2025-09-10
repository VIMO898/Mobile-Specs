import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class DeviceOverviewModel {
  final String id;
  final String name;
  final String imgUrl;
  final String link;
  final String? subtitle;
  const DeviceOverviewModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.link,
    this.subtitle,
  });

  @override
  String toString() {
    return 'DeviceOverviewModel(id: $id, name: $name, imgUrl: $imgUrl, link: $link, subtitle: $subtitle)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
      'link': link,
      'subtitle': subtitle,
    };
  }

  factory DeviceOverviewModel.fromMap(Map<String, dynamic> map) {
    return DeviceOverviewModel(
      id: map['id'] as String,
      name: map['name'] as String,
      imgUrl: map['imgUrl'] as String,
      link: map['link'] as String,
      subtitle: map['subtitle'] != null ? map['subtitle'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceOverviewModel.fromJson(String source) =>
      DeviceOverviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  DeviceOverviewModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
    String? link,
    String? subtitle,
  }) {
    return DeviceOverviewModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      link: link ?? this.link,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}
