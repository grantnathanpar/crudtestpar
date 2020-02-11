import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './home.dart';
import '../database_config/firestore_service.dart';
import '../models/photos.dart';

class UploadingScreen extends StatefulWidget {
  static const routeName = 'uploading';

  @override
  _UploadingScreenState createState() => _UploadingScreenState();
}

class _UploadingScreenState extends State<UploadingScreen> {
  bool _isclicked = false;
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

  @override
  Widget build(BuildContext context) {
    final List photolist = ModalRoute.of(context).settings.arguments;
    var texteditingcontrollers = <TextEditingController>[];

    photolist.forEach((photo) {
      var texteditingcontroller = TextEditingController();
      texteditingcontrollers.add(texteditingcontroller);
    });

    Future<List<String>> uploadimage() async {
      List<String> uploadurls = [];

      await Future.wait(
          photolist.map((asset) async {
            Random rng = new Random();
            int n = rng.nextInt(999999);
            ByteData byteData = await asset.requestOriginal();
            List<int> imageData = byteData.buffer.asUint8List();

            StorageReference reference =
                FirebaseStorage.instance.ref().child(n.toString() + ".jpg");
            StorageUploadTask uploadTask = reference.putData(imageData);
            StorageTaskSnapshot storageTaskSnapshot;

            StorageTaskSnapshot snapshot = await uploadTask.onComplete;
            if (snapshot.error == null) {
              storageTaskSnapshot = snapshot;
              final String downloadUrl =
                  await storageTaskSnapshot.ref.getDownloadURL();
              uploadurls.add(downloadUrl);
              print('success');
            } else {
              print('error ${snapshot.error.toString()}');
            }
          }),
          eagerError: true,
          cleanUp: (_) {
            print('eager clean up');
          });
      return uploadurls;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            children: List.generate(photolist.length, (index) {
              Asset asset = photolist[index];
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey[700],
                      style: BorderStyle.solid,
                      width: 1.5),
                ),
                child: Row(
                  children: <Widget>[
                    AssetThumb(
                      asset: asset,
                      width: 100,
                      height: 100,
                    ),
                    Container(
                      width: 170,
                      margin: EdgeInsets.only(left: 20),
                      child: TextField(
                        maxLength: 10,
                        controller: texteditingcontrollers[index],
                        decoration:
                            InputDecoration(hintText: 'Insert Label Here'),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[700],
          child: !_isclicked
              ? Icon(
                  Icons.file_upload,
                )
              : CircularProgressIndicator(),
          onPressed: !_isclicked
              ? () async {
                  setState(() {
                    _isclicked = true;
                  });
                  List<String> url = await uploadimage();
                  photolist.asMap().forEach((index, photo) async {
                    try {
                      await FirestoreService().addphoto(Photos(
                        label: texteditingcontrollers[index].text.isEmpty
                            ? "label"
                            : texteditingcontrollers[index].text,
                        uploader: _username,
                        photourl: url[index],
                      ));
                    } catch (e) {
                      print(e);
                    }
                  });
                  Navigator.of(context)
                      .pushReplacementNamed(HomeScreen.routeName);
                }
              : null),
    );
  }
}
