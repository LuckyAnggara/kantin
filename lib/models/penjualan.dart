import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Penjualan {
  String? idBarang;
  double? hargaJual;

  Penjualan({
    required this.idBarang,
    required this.hargaJual,
  });
}

class SiapJual {
  String? id;
  String? nama;
  double? total;
  int? jumlah;

  SiapJual({
    required this.id,
    required this.nama,
    required this.jumlah,
    required this.total,
  });
}

class Keranjang {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Penjualan>? _keranjang = [];

  List<Penjualan>? get getList {
    return _keranjang;
  }

  Future<List<SiapJual>> get getList2 {
    List<SiapJual>? _total = [];
    Future<List<SiapJual>> data =
        _firestore.collection('barang').get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        int jumlah = _keranjang!.where((x) => x.idBarang == result.id).length;
        double total = result.get('harga') * jumlah;
        _total.add(
          SiapJual(
            id: result.id,
            nama: result.get('nama'),
            jumlah: jumlah,
            total: total,
          ),
        );
      }

      return _total.toList();
    });
    return data;
  }

  void addItem(Penjualan penjualan) {
    _keranjang!.add(penjualan);
  }

  void removeItem(String idBarang) {
    var data = _keranjang?.where((row) => (row.idBarang!.contains(idBarang)));
    var item = data?.first;
    _keranjang?.remove(item);
  }
}
