import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ModalWithPageView extends StatelessWidget {
  const ModalWithPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF545D68),
            ),
          ),
          title: const Text(
            'New Product',
            style: TextStyle(
              fontFamily: 'Varela',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF545D68),
            ),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              controller: ModalScrollController.of(context),
              children: ListTile.divideTiles(
                context: context,
                tiles: List.generate(
                  100,
                  (index) => ListTile(
                    title: Text('Item'),
                  ),
                ),
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
