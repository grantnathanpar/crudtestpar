import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/photos.dart';
import '../models/hearts.dart';
import '../database_config/firestore_service.dart';
import './editmodal.dart';
import './likemodal.dart';

class PhotooptionsScreen extends StatefulWidget {
  static const routeName = 'photooptions';

  @override
  _PhotooptionsScreenState createState() => _PhotooptionsScreenState();
}

class _PhotooptionsScreenState extends State<PhotooptionsScreen> {
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
    final Photos photo = ModalRoute.of(context).settings.arguments;
    void starteditmodal(BuildContext ctx) {
      showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return EditModal(photo);
          });
    }

    void startlikemodal(BuildContext ctx) {
      showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return LikeModal(photo.id);
          });
    }

    void deletephoto() async {
      try {
        await FirestoreService().deletephoto(photo.id);
      } catch (e) {
        print(e);
      }
    }

    AlertDialog alert = AlertDialog(
      title: Text('Delete'),
      content: Text('Are you sure you want to delete this photo?'),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('home'));
            deletephoto();
          },
        )
      ],
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              photo.photourl,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    _username == photo.uploader
                        ? FlatButton(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  });
                            },
                          )
                        : Container(
                            width: 250,
                          ),
                    _username == photo.uploader
                        ? FlatButton(
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              starteditmodal(context);
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection("photos")
                            .document(photo.id)
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          return Text(
                            snapshot.data["label"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white),
                          );
                        }),
                    Text(
                      photo.uploader,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    StreamBuilder(
                      stream: FirestoreService().gethearts(photo.id),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Hearts>> snapshot) {
                        if (snapshot.hasError || !snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        return RaisedButton(
                          color: Colors.grey[600],
                          child: Container(
                            padding: EdgeInsets.only(right: 30),
                            child: Text(
                              snapshot.data.length.toString() + ' likes',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          onPressed: () {
                            startlikemodal(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
