import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wowow/const/custom_color.dart';
import 'package:wowow/models/database.dart';
import 'package:wowow/models/penjualan.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final Keranjang keranjang = Keranjang();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showMaterialModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 200,
            child: FutureBuilder<List<SiapJual>>(
              future: keranjang.getList2,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${snapshot.data![index].nama}'),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: Color(0xFFD17E59),
                                        size: 14,
                                      ),
                                    ),
                                    Text(
                                      '${snapshot.data![index].jumlah}',
                                      style: TextStyle(
                                        color: Color(0xFFD17E50),
                                        fontFamily: 'Varela',
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Color(0xFFD17E59),
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
        backgroundColor: Color(0xFFF17532),
        label: Row(
          children: const [
            Icon(Icons.shopping_basket_outlined),
            SizedBox(
              width: 10,
            ),
            Text('Keranjang')
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 20.0),
          children: [
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Pilih Barang',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 30,
              width: double.infinity,
              child: Scaffold(
                  backgroundColor: Color(0xFFFCFAF8),
                  body: ListView(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: Database.readItems(),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Ooppss');
                            } else if (snapshot.hasData ||
                                snapshot.data != null) {
                              return Container(
                                  padding: EdgeInsets.only(right: 15.0),
                                  width:
                                      MediaQuery.of(context).size.width - 30.0,
                                  height:
                                      MediaQuery.of(context).size.height - 50.0,
                                  child: GridView.builder(
                                      physics: BouncingScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 15.0,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        var detailBarang =
                                            snapshot.data!.docs[index];

                                        return _buildProduct(
                                            detailBarang, keranjang);
                                      }));
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.firebaseOrange,
                                ),
                              ),
                            );
                          }),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProduct(QueryDocumentSnapshot product, Keranjang keranjang) {
    var data =
        keranjang.getList?.where((row) => (row.idBarang!.contains(product.id)));
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5.0)
            ],
            color: Colors.white),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Penjualan penjualan = Penjualan(
                  idBarang: product.id,
                  hargaJual: product.get('harga'),
                );
                keranjang.addItem(penjualan);
                setState(() {});
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        product.get("isFavorite") == true
                            ? Icon(
                                Icons.favorite,
                                color: Color(0xFFEF7532),
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Color(0xFFEF7532),
                              ),
                      ],
                    ),
                  ),
                  Hero(
                    tag: '${product.get('nama')}',
                    child: Container(
                      height: MediaQuery.of(context).size.height / 8,
                      width: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('${product.get('gambar')}'),
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    'Rp. ${product.get('harga')}',
                    style: TextStyle(
                      color: Color(0xFFCC8053),
                      fontFamily: 'Varela',
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '${product.get('nama')}',
                    style: TextStyle(
                      color: Color(0xFF575E67),
                      fontFamily: 'Varela',
                      fontSize: 15.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      color: Color(0xFFEBEBEB),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            data!.isNotEmpty
                ? Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              keranjang.removeItem(product.id);
                              setState(() {});
                            },
                            child: Icon(
                              Icons.remove,
                              color: Color(0xFFD17E59),
                              size: 14,
                            ),
                          ),
                          Text(
                            '${data.length}',
                            style: TextStyle(
                              color: Color(0xFFD17E50),
                              fontFamily: 'Varela',
                              fontSize: 12.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Penjualan penjualan = Penjualan(
                                idBarang: product.id,
                                hargaJual: product.get('harga'),
                              );
                              keranjang.addItem(penjualan);
                              setState(() {});
                            },
                            child: Icon(
                              Icons.add,
                              color: Color(0xFFD17E59),
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Penjualan penjualan = Penjualan(
                        idBarang: product.id,
                        hargaJual: product.get('harga'),
                      );
                      keranjang.addItem(penjualan);
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.shopping_basket,
                            color: Color(0xFFD17E59),
                            size: 14,
                          ),
                          Text(
                            'Tambah ke Keranjang',
                            style: TextStyle(
                              color: Color(0xFFD17E50),
                              fontFamily: 'Varela',
                              fontSize: 12.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
