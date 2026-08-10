import 'package:cloud_firestore/cloud_firestore.dart';

/// CoffeeRecordsModel
///
/// A quicktype-style Dart model for a single coffee record.
/// It supports converting to/from a Map so it can be stored in and read
/// back from Cloud Firestore.
class CoffeeRecordsModel {
  /// Firestore document id. Null before the record is written to Firestore.
  final String? docId;

  final int id;
  final String title;
  final String des;
  double? amount;
  final DateTime date;

  CoffeeRecordsModel({
    this.docId,
    required this.id,
    required this.title,
    required this.des,
    this.amount,
    required this.date,
  });

  /// Convert this model into a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "des": des,
      "amount": amount,
      // Store the date as a Firestore Timestamp for proper ordering/queries.
      "date": Timestamp.fromDate(date),
    };
  }

  /// Build a model from a plain Map (e.g. json / Firestore data).
  factory CoffeeRecordsModel.fromMap(
    Map<String, dynamic> map, {
    String? docId,
  }) {
    return CoffeeRecordsModel(
      docId: docId,
      id: (map["id"] ?? 0) as int,
      title: (map["title"] ?? "") as String,
      des: (map["des"] ?? "") as String,
      amount: (map["amount"] as num?)?.toDouble(),
      date: _parseDate(map["date"]),
    );
  }

  /// Build a model directly from a Firestore document snapshot.
  factory CoffeeRecordsModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return CoffeeRecordsModel.fromMap(data, docId: doc.id);
  }

  /// Return a copy with some fields replaced (handy for updates).
  CoffeeRecordsModel copyWith({
    String? docId,
    int? id,
    String? title,
    String? des,
    double? amount,
    DateTime? date,
  }) {
    return CoffeeRecordsModel(
      docId: docId ?? this.docId,
      id: id ?? this.id,
      title: title ?? this.title,
      des: des ?? this.des,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
