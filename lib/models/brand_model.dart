import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BrandModel {
  final String name;
  final String link;
  final String imgUrl;
  const BrandModel(
      {required this.name, required this.link, required this.imgUrl});

  @override
  String toString() => 'BrandModel(name: $name, link: $link, imgUrl: $imgUrl)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'link': link,
      'imgUrl': imgUrl,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      name: map['name'] as String,
      link: map['link'] as String,
      imgUrl: map['imgUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandModel.fromJson(String source) =>
      BrandModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
