import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_shop/book_list_page.dart';
import 'package:search_shop/login_view.dart';
import 'package:search_shop/main_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_users.dart';
import 'home_users_page.dart';
import 'map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'post.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(login_view());
}

class login_view extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/add_post': (_) => new add_post(),
      },
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
  GoogleMapController mapController;

  // 表示する Widget の一覧
  static List<Widget> _pageList = [post_users(), example1()];
  //これでwidgetは動的なサイズになる
  //MediaQuery.of(context).size.width * 0.65
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(33.52101735482, 130.4580783311),
          zoom: 12.0,
        ),
      ));
    });
  }

  //円形の画像
  Widget _userIconImage() {
    return new Container(
//        color: Colors.green,
        width: MediaQuery.of(context).size.width * 0.08,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(
                    "https://contents.oricon.co.jp/images/news/20191020/2146864_201910200723487001571579615e-w1200_h667.jpg?LB=true"))));
  }

  //円形の画像と誰が投稿したか表示するウィジェット
  Widget _userIconAndName(String name) {
    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _userIconImage(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Text(
          name,
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
  Widget _postPicture(String post_picture) {
    return Image.network(
      post_picture,
    );
  }

  //位置情報を表示する
  Widget _location(String location) {
    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_rounded,
          size: 30,
          color: Colors.red,
        ),
        Text(
          location,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        )
      ],
    );
  }

  //投稿内容
  Widget _context(String context) {
    return Text(
      context,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
    );
  }

  Widget _GoodAndComment(int good) {
    String str_good;
    str_good = good.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton.icon(
          icon: const Icon(
            Icons.tag_faces,
            color: Colors.white,
          ),
          label: Row(
            children: [
              const Text(
                'good!!!',
              ),
              Text(
                str_good,
              ),
            ],
          ),
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

  //投稿を追加する width: MediaQuery.of(context).size.width * 0.5,
  Widget add_post() {
    return ButtonTheme(
      child: FloatingActionButton.extended(
        tooltip: 'Action!',
        icon: Icon(Icons.add), //アイコンは無しでもOK
        label: Text('New Post'),
        onPressed: () {
          Navigator.of(context).pushNamed('/add_post');
        },
        splashColor: Colors.purple,
      ),
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
                        _userIconAndName(
                          document['author'],
                        ), //Rowにて（画像：投稿者）を表示
                        Container(
                          width: MediaQuery.of(context).size.width * 1.0,
                          height: MediaQuery.of(context).size.width * 0.6,
                          child: _postPicture(document['post-picture']),
                        ),
                        _location(document['location']),
                        _context(document['context']),
                        _GoodAndComment(document['good'])
                      ],
                    );
                  }).toList(),
                ),
              );
              break;
            case 1:
              return example1();
              break;
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: add_post(),
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
