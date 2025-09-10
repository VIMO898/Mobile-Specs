import 'dart:convert';

import 'package:app/models/user_activity_entry_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserActivityModel {
  final List<UserActivityEntryModel>? wishlist;
  final List<UserActivityEntryModel>? news;
  final List<UserActivityEntryModel>? comparedDevices;
  final List<UserActivityEntryModel>? history;

  const UserActivityModel({
    required this.wishlist,
    required this.comparedDevices,
    required this.history,
    required this.news,
  });

  @override
  String toString() {
    return 'UserActivityModel(wishlist: $wishlist, news: $news, comparedDevices: $comparedDevices, history: $history)';
  }

  UserActivityModel copyWith({
    List<UserActivityEntryModel>? wishlist,
    List<UserActivityEntryModel>? news,
    List<UserActivityEntryModel>? comparedDevices,
    List<UserActivityEntryModel>? history,
  }) {
    return UserActivityModel(
      wishlist: wishlist ?? this.wishlist,
      news: news ?? this.news,
      comparedDevices: comparedDevices ?? this.comparedDevices,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wishlist': wishlist?.map((x) => x.toMap()).toList(),
      'news': news?.map((x) => x.toMap()).toList(),
      'comparedDevices': comparedDevices?.map((x) => x.toMap()).toList(),
      'history': history?.map((x) => x.toMap()).toList(),
    };
  }

  factory UserActivityModel.fromMap(Map<String, dynamic> map) {
    return UserActivityModel(
      wishlist: map['wishlist'] != null
          ? List<UserActivityEntryModel>.from(
              (map['wishlist']).map<UserActivityEntryModel?>(
                (x) =>
                    UserActivityEntryModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      news: map['news'] != null
          ? List<UserActivityEntryModel>.from(
              (map['news']).map<UserActivityEntryModel?>(
                (x) => UserActivityEntryModel.fromMap(x),
              ),
            )
          : null,
      comparedDevices: map['comparedDevices'] != null
          ? List<UserActivityEntryModel>.from(
              (map['comparedDevices']).map<UserActivityEntryModel?>(
                (x) => UserActivityEntryModel.fromMap(x),
              ),
            )
          : null,
      history: map['history'] != null
          ? List<UserActivityEntryModel>.from(
              (map['history']).map<UserActivityEntryModel?>(
                (x) => UserActivityEntryModel.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserActivityModel.fromJson(String source) =>
      UserActivityModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
