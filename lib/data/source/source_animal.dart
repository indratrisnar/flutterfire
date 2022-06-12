import 'package:cloud_firestore/cloud_firestore.dart';

class SourceAnimal {
  static final _db = FirebaseFirestore.instance;

  static Future<List<Map<String, dynamic>>> gets() async {
    QuerySnapshot<Map<String, dynamic>> response = await _db
        .collection("Animal")
        .orderBy('name', descending: false)
        .limit(10)
        .get();
    return response.docs.map((e) => e.data()).toList();
  }

  static Future<bool> add(Map<String, dynamic> data) async {
    final response = await _db.collection("Animal").add(data);
    response.update({'id': response.id});
    return true;
  }

  static Future<bool> update(Map<String, dynamic> data) async {
    await _db.collection("Animal").doc(data['id']).update(data);
    return true;
  }

  static Future<bool> delete(String id) async {
    await _db.collection("Animal").doc(id).delete();
    return true;
  }
}
