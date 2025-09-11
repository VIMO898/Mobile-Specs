import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewsOverviewModel {
  final String id;
  final String title;
  final String subtitle;
  final String imgUrl;
  final String uploadedTime;
  final String link;
  const NewsOverviewModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imgUrl,
    required this.link,
    required this.uploadedTime,
  });

  @override
  String toString() {
    return 'NewsOverviewModel(id: $id, title: $title, subtitle: $subtitle, imgUrl: $imgUrl, uploadedTime: $uploadedTime, link: $link)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imgUrl': imgUrl,
      'uploadedTime': uploadedTime,
      'link': link,
    };
  }

  factory NewsOverviewModel.fromMap(Map<String, dynamic> map) {
    return NewsOverviewModel(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      imgUrl: map['imgUrl'],
      uploadedTime: map['uploadedTime'],
      link: map['link'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsOverviewModel.fromJson(String source) =>
      NewsOverviewModel.fromMap(json.decode(source));
}
