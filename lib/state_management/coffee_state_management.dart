import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';

class CoffeeStateManagement with ChangeNotifier {
  /// Local in-memory list (kept from the original class demo).
  List<CoffeeRecordsModel> items = [];

  /// Firestore instance and the "coffeeRecords" collection reference.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection("coffeeRecords");

  // ---------------------------------------------------------------------------
  // LOCAL (original demo) methods
  // ---------------------------------------------------------------------------

  void addData() {
    items.add(
      CoffeeRecordsModel(
        id: DateTime.now().microsecondsSinceEpoch,
        title: "Coffee Record ${items.length + 1}",
        des: "Details about Coffee Record ${items.length + 1}",
        amount: 10.0,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addCoffeeRecord(CoffeeRecordsModel coffeeRecord) {
    items.add(
      CoffeeRecordsModel(
        id: DateTime.now().microsecondsSinceEpoch,
        title: coffeeRecord.title,
        des: coffeeRecord.des,
        amount: coffeeRecord.amount,
        date: coffeeRecord.date,
      ),
    );
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // FIREBASE / FIRESTORE — CRUD
  // ---------------------------------------------------------------------------

  /// CREATE — send a new coffee record to Firestore.
  Future<void> addCoffeeRecordToFirebase(CoffeeRecordsModel record) async {
    await _collection.add(record.toMap());
    // No need to notifyListeners(): the StreamBuilder listens to snapshots
    // and updates the UI in real time automatically.
  }

  /// READ (real-time) — a live stream of all coffee records, newest first.
  Stream<List<CoffeeRecordsModel>> get coffeeRecordsStream {
    return _collection
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CoffeeRecordsModel.fromSnapshot(doc))
          .toList();
    });
  }

  /// READ (raw) — expose the raw query snapshot stream if a screen wants to
  /// build directly from a QuerySnapshot in the StreamBuilder.
  Stream<QuerySnapshot<Map<String, dynamic>>> get rawSnapshots {
    return _collection.orderBy("date", descending: true).snapshots();
  }

  /// UPDATE — update an existing record by its Firestore document id.
  Future<void> updateCoffeeRecord(CoffeeRecordsModel record) async {
    final id = record.docId;
    if (id == null) return;
    await _collection.doc(id).update(record.toMap());
  }

  /// DELETE — remove a record by its Firestore document id.
  Future<void> deleteCoffeeRecord(String docId) async {
    await _collection.doc(docId).delete();
  }
}
