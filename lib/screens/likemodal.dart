import 'package:flutter/material.dart';
import '../database_config/firestore_service.dart';
import '../models/hearts.dart';

class LikeModal extends StatelessWidget {
  final String id;

  LikeModal(this.id);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 600,
        child: StreamBuilder(
          stream: FirestoreService().gethearts(id),
          builder:
              (BuildContext context, AsyncSnapshot<List<Hearts>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        snapshot.data.length.toString() + ' likes',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    FlatButton(
                      child: Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                Container(
                  child: Column(
                    children: List.generate(snapshot.data.length, (index) {
                      Hearts heart = snapshot.data[index];
                      return Text(heart.email);
                    }),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
