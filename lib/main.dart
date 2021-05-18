import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_shop/book_list_page.dart';
import 'package:search_shop/login_view.dart';
import 'package:search_shop/main_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<MainModel>(
          create: (_) => MainModel(), child: welcome_screen()),
    );
  }

  Widget welcome_screen() {
    return Scaffold(
      appBar: AppBar(title: Text("ようこそ！！")),
      body: Consumer<MainModel>(builder: (context, model, child) {
        return Column(
          children: [
            RaisedButton(
              child: Text('ログインする'),
              onPressed: () {
                // ここでなにか
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => login_view()),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
