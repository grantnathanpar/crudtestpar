import 'package:crudtestpar/screens/photooptions.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/photos.dart';
import '../database_config/firestore_service.dart';
import './uploading.dart';
import '../models/hearts.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Asset> images = List<Asset>();
  String _username = '';

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        this._username = user.displayName;
      });
    });
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
      );
    } catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });

    Navigator.pushNamed(
      context,
      UploadingScreen.routeName,
      arguments: images,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirestoreService().getPhotos(),
        builder: (BuildContext context, AsyncSnapshot<List<Photos>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Photos photo = snapshot.data[index];
                return FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PhotooptionsScreen.routeName,
                        arguments: photo);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Image.network(
                            photo.photourl,
                            width: 75,
                            height: 75,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              photo.label,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              "Posted by " + photo.uploader,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            FlatButton(
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey[700],
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  await FirestoreService().addheart(
                                      photo.id,
                                      Hearts(
                                        email: _username,
                                      ));
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(left: 20),
                              child: StreamBuilder(
                                  stream:
                                      FirestoreService().gethearts(photo.id),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<Hearts>> snapshot) {
                                    if (snapshot.hasError ||
                                        !snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    return Text(
                                        snapshot.data.length.toString());
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.grey,
        onPressed: loadAssets,
      ),
    );
  }
}
