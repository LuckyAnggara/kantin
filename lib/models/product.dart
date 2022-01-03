import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _barangCollection = _firestore.collection('barang');

class Product {
  final String? name, img;
  final double? price;
  final bool? isFavorite;

  Product({required this.name, required this.img, required this.price, required this.isFavorite});

  static Future<void> addItem({
    required String name,
    img,
    required double price,
  }) async {
    DocumentReference documentReferencer = _barangCollection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "nama": name,
      "harga": price,
      "gambar": img,
      "isFavorite": false,
    };

    await documentReferencer.set(data).catchError((e) => print(e));
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer = _firestore.collection('barang').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
