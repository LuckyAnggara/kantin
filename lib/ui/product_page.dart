import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wowow/const/custom_color.dart';
import 'package:wowow/models/database.dart';
import 'package:wowow/ui/product_new.dart';
import 'package:wowow/widget/floating_modal.dart';
import 'package:wowow/widget/modal_fit.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'newProduct',
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductNew(),
            ),
          );
        },
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Column(
          children: [
            SizedBox(
              height: 15.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Produk',
                style: TextStyle(fontFamily: 'Varela', fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Database.readItems(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Ooppss');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      // the number of items in the list
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      // display each item of the product list
                      itemBuilder: (context, index) {
                        var detailBarang = snapshot.data!.docs[index];
                        return _buildCard(detailBarang, context);
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.firebaseOrange,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(QueryDocumentSnapshot product, ctx) {
    return Card(
      elevation: 5.0,
      child: InkWell(
        onTap: () => showFloatingModalBottomSheet(
          context: ctx,
          backgroundColor: Colors.transparent,
          builder: (context) => ModalFit(
            edit: () {},
            delete: () async {
              await Database.deleteItem(
                docId: product.id,
              );
              Navigator.of(context).pop();
              Flushbar(
                leftBarIndicatorColor: Colors.blue[300],
                message: "${product.get('nama')} telah di hapus!!",
                icon: Icon(
                  Icons.info_outline,
                  size: 28.0,
                  color: Colors.red,
                ),
                duration: Duration(seconds: 2),
              )..show(context);
            },
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white60),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.black),
                ),
              ),
              child: Text(
                '${product.get('nama')[0]}',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            title: Text(
              '${product.get('nama')}',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
