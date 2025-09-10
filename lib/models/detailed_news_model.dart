import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DetailedNewsModel {
  final String title;
  final String description;
  final List<String> tags;
  final String reviewer;
  const DetailedNewsModel({
    required this.title,
    required this.description,
    required this.reviewer,
    required this.tags,
  });

  @override
  String toString() {
    return 'DetailedNewsModel(title: $title, description: $description, tags: $tags, reviewer: $reviewer)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'tags': tags,
      'reviewer': reviewer,
    };
  }

  factory DetailedNewsModel.fromMap(Map<String, dynamic> map) {
    return DetailedNewsModel(
      title: map['title'] as String,
      description: map['description'],
      tags: List<String>.from((map['tags'])),
      reviewer: map['reviewer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailedNewsModel.fromJson(String source) =>
      DetailedNewsModel.fromMap(json.decode(source));
}
