import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'login_view.dart';

class add_post extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/login_view': (_) => new login_view(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //テキストフィールドから入力された名前、それをfirestoreにpost_nameにて渡す
  String set_name = "";
  String post_name = "";

  //テキストフィールドから入力された文章、それをfirestoreにpost_contextにて渡す
  String set_context = "";
  String post_context = "";

  //テキストフィールドから入力された場所、それをfirestoreにpost_locationにて渡す
  String set_location = "";
  String post_location = "";

  //テキストフィールドから入力された場所、それをfirestoreにpost_pictureにて渡す
  String set_picture = "";
  String post_picture = "";

  //イメージピッカーに使用
  final picker = ImagePicker();
  //ファイルIDを持ってくる
  File _image;

  //imagepickerの実装
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        print("image path is----->");
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  _uproadURL() async {
    print("debug1");
    var storage = FirebaseStorage.instance;
    print("debug2");

//    TaskSnapshot snapshot =
//        await storage.ref().child("books/$post_name").putFile(_image);
//    print("debug3");
//    final String downloadUrl = await snapshot.ref.getDownloadURL();
//    print("debug4");
//    return "https://dy1ar1zj7xlg8.cloudfront.net/wp-content/uploads/2019/10/70aa6564c1bba96149d348036d0ca931.jpg";

    final ref = storage.ref().child('books').child(post_name);
    final snapshot = await ref.putFile(
      _image,
    );
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  //イメージピッカーのウィジェット
  Widget PictureAndAdd(String picture_url) {
    return Stack(
      children: [
        Center(
          child: Image.network(
            picture_url,
          ),
        ),
        Center(
          child: Opacity(
            opacity: 0.2,
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.9),
              child: ElevatedButton(
                child: Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: getImage,
              ),
            ),
          ),
        ),
      ],
    );
  }

  dialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.3),
          content: Text(
            'ご投稿ありがとうございました！!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text(
                "戻る",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              elevation: 16.0,
              color: Colors.orange.withOpacity(0.8),
              splashColor: Colors.purple,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新規の投稿をする"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // 枠線
                    border: Border.all(color: Colors.blue, width: 2),
                    // 角丸
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Stack(
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints.expand(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.9),
                          child: ElevatedButton(
                            child: Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.blue,
                            ),
                            onPressed: getImage,
                          ),
                        ),
                      ),
                      Center(
                        //ここでイメージピッカー
                        child: _image == null
                            ? Icon(
                                Icons.add,
                                color: Colors.blue,
                                size: 50,
                              )
                            : Image.file(_image),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: TextField(
                          decoration: InputDecoration(
                            hintText: '名前を入力してください',
                          ),
                          onChanged: (set_name) {
                            setState(() {
                              post_name = set_name;
                            });
                          }),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: TextField(
                          decoration: InputDecoration(
                            hintText: '場所を入力してください',
                          ),
                          onChanged: (set_location) {
                            setState(() {
                              post_location = set_location;
                            });
                          }),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Center(
                      child: TextField(
                          decoration: InputDecoration(
                            hintText: '投稿内容を入力してください',
                          ),
                          onChanged: (set_context) {
                            setState(() {
                              post_context = set_context;
                            });
                          }),
                    )),
                Container(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.post_add,
                      color: Colors.white,
                    ),
                    label: const Text('投稿する'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () async {
                      print("onpressed is occured");
                      //firebase storageからアップロードされたやつ
                      String uproad_picture_url = await _uproadURL();

                      print("uproad_picture_url is ↓");
                      print(uproad_picture_url);
                      print("post name is ↓");
                      print(post_name);
                      print("post context is ↓");
                      print(post_context);
                      print("post location  is ↓");
                      print(post_location);

//                          "https://dy1ar1zj7xlg8.cloudfront.net/wp-content/uploads/2019/10/70aa6564c1bba96149d348036d0ca931.jpg";
                      //ここでbookコレクションに新しいデータセットを作成
                      FirebaseFirestore.instance.collection('books').add({
                        "author": post_name,
                        "context": post_context,
                        "location": post_location,
                        "good": 0,
                        "post-picture": uproad_picture_url,
                      });

                      Navigator.of(context).pushNamed('/login_view');
                      //ありがとうございましたのダイアログを表示
                      dialog();
                    },
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
    ;
  }
}

//class FileController {
////storageに保存
//  static void upload(File file) async {
//    final StorageReference ref = FirebaseStorage.instance.ref();
//    final StorageTaskSnapshot storedImage =
//        await ref.child('folder-name').putFile(File(file.path)).onComplete;
//    final String downloadUrl = await loadImage(storedImage);
//  }
//
//  //url取得
//  static Future<String> loadImage(StorageTaskSnapshot storedImage) async {
//    if (storedImage.error == null) {
//      print('storageに保存しました');
//      final String downloadUrl = await storedImage.ref.getDownloadURL();
//      return downloadUrl;
//    } else {
//      return null;
//    }
//  }
//}
