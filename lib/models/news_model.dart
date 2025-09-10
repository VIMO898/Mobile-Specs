// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app/models/detailed_news_model.dart';
import 'package:app/models/news_overview_model.dart';

class NewsModel {
  final NewsOverviewModel overview;
  final DetailedNewsModel details;
  const NewsModel({required this.overview, required this.details});

  @override
  String toString() => 'NewsModel(overview: $overview, details: $details)';

  NewsModel copyWith({
    NewsOverviewModel? overview,
    DetailedNewsModel? details,
  }) {
    return NewsModel(
      overview: overview ?? this.overview,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'overview': overview.toMap(),
      'details': details.toMap(),
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      overview: NewsOverviewModel.fromMap(map['overview']),
      details: DetailedNewsModel.fromMap(map['details']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source));
}
