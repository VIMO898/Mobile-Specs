import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserActivityEntryModel {
  final String id;
  final int timestamp;
  UserActivityEntryModel({
    required this.id,
    required this.timestamp,
  });

  @override
  String toString() => 'HistoryEntry(id: $id, timestamp: $timestamp)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'timestamp': timestamp,
    };
  }

  factory UserActivityEntryModel.fromMap(Map<String, dynamic> map) {
    return UserActivityEntryModel(
      id: map['id'] as String,
      timestamp: map['timestamp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserActivityEntryModel.fromJson(String source) =>
      UserActivityEntryModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  UserActivityEntryModel copyWith({
    String? id,
    int? timestamp,
  }) {
    return UserActivityEntryModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
