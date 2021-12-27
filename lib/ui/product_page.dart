import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wowow/const/custom_color.dart';
import 'package:wowow/models/database.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return Container(
                        padding: EdgeInsets.only(right: 15.0),
                        width: MediaQuery.of(context).size.width - 30.0,
                        height: MediaQuery.of(context).size.height - 50.0,
                        child: GridView.builder(
                            physics: BouncingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 15.0,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, index) {
                              var detailBarang = snapshot.data!.docs[index];

                              return _buildProduct(detailBarang);
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
        ));
  }

  Widget _buildProduct(QueryDocumentSnapshot product) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 3, blurRadius: 5.0)
              ],
              color: Colors.white),
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
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('${product.get('gambar')}'), fit: BoxFit.contain)),
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
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
