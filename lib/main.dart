import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wowow/const/custom_color.dart';
import 'package:wowow/ui/product_page.dart';
import 'package:wowow/ui/sales_page.dart';
import 'package:wowow/widget/bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FocusNode _uidFocusNode = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error initializing Firebase');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              // centerTitle: true,
              // leading: IconButton(
              //   onPressed: () {},
              //   icon: const Icon(
              //     Icons.arrow_back,
              //     color: Color(0xFF545D68),
              //   ),
              // ),
              title: const Text(
                'GAK TAU',
                style: TextStyle(
                  fontFamily: 'Varela',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF545D68),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Color(0xFF545D68),
                  ),
                ),
              ],
            ),
            body: ProductPage(),
            floatingActionButton: FloatingActionButton(
              heroTag: 'newSales',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalesPage(),
                  ),
                );
              },
              backgroundColor: Color(0xFFF17532),
              child: Icon(Icons.fastfood),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomBar(),
          );
        }
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(CustomColors.firebaseOrange),
        );
      },
    );
  }
}
