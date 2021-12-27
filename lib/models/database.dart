import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _barangCollection = _firestore.collection('barang');

class Database {
  static String? userUid;

  static Future<void> addItem({
    required String nama,
    required double harga,
  }) async {
    DocumentReference documentReference = _barangCollection.doc().collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "nama": nama,
      "harga": harga,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print('Data berhasil di tambah'))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference barangCollection = _firestore.collection('barang');
    return barangCollection.snapshots();
  }
}

class Barang {
  static String? nama;
  static double? harga;

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'harga': harga,
    };
  }
}
