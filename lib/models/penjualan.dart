class Penjualan {
  String? idBarang;
  double? hargaJual;

  Penjualan({
    required this.idBarang,
    required this.hargaJual,
  });
}

class Keranjang {
  final List<Penjualan>? _keranjang = [];

  List<Penjualan>? get getList {
    return _keranjang;
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
