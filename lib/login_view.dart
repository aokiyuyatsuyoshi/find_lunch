import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_shop/book_list_page.dart';
import 'package:search_shop/login_view.dart';
import 'package:search_shop/main_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_users.dart';
import 'home_users_page.dart';

void main() {
  runApp(login_view());
}

class login_view extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'みんなで作る僕らのご飯'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //bottombarを使う時に必要
  int _selectedIndex = 0;
  // 表示する Widget の一覧
  static List<Widget> _pageList = [
    post_users(),
    home_users_page(),
    post_users()
  ];
  //これでwidgetは動的なサイズになる
  //MediaQuery.of(context).size.width * 0.65

  //円形の画像
  Widget _userIconImage() {
    return new Container(
//        color: Colors.green,
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(
                    "https://contents.oricon.co.jp/images/news/20191020/2146864_201910200723487001571579615e-w1200_h667.jpg?LB=true"))));
  }

  //円形の画像と誰が投稿したか表示するウィジェット
  Widget _userIconAndName() {
    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _userIconImage(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Text(
          "橋本環奈",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          "さんが投稿しました！",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  //投稿した写真
  Widget _postPicture() {
    return Image.network(
        "https://www.fujitv-view.jp/tachyon/2021/01/M_006.jpg?resize=1536,864&crop=0px,0px,1920px,1080px");
  }

  //位置情報を表示する
  Widget _location() {
    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_rounded,
          size: 30,
        ),
        Text(
          "関西学院大学三田キャンパス",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        )
      ],
    );
  }

  //投稿内容
  Widget _context() {
    return Text(
      '''　最近Go言語とGCPばっかり触っていてFlutterを書く機会がなかったので、今回はFlutterとFirebaseによるSNSを作ろうと思います！認証機能にはfirebase Auth、データベースにはFireStore、マップにはGoogle Maps SDKを使用します！会社の人たちに使ってもらえるようにがんばります！アーキテクチャはMVVM予定しています（この画面はStatefulwidgetなのでテストきつい）''',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
    );
  }

  Widget _GoodAndComment() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton.icon(
          icon: const Icon(
            Icons.tag_faces,
            color: Colors.white,
          ),
          label: const Text('good!!!'),
          onPressed: () {},
          splashColor: Colors.purple,
          color: Colors.green,
          textColor: Colors.white,
        ),
        RaisedButton.icon(
          icon: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
          label: const Text('comment!!!'),
          onPressed: () {},
          splashColor: Colors.pinkAccent,
          color: Colors.blue,
          textColor: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('books').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (_selectedIndex) {
            case 0:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _userIconAndName(), //Rowにて（画像：投稿者）を表示
                        Container(
                          width: MediaQuery.of(context).size.width * 1.0,
                          height: MediaQuery.of(context).size.width * 0.6,
                          child: _postPicture(),
                        ),
                        _location(),
                        _context(),
                        _GoodAndComment()
                      ],
                    );
                  }).toList(),
                ),
              );
              break;
            case 1:
              return Text("2");
              break;
            case 2:
              return Text("3");
              break;
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('投稿一覧'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('店を探す'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('マイページ'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // タップ時の処理
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
