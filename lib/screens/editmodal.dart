import 'package:flutter/material.dart';
import '../database_config/firestore_service.dart';
import '../models/photos.dart';

class EditModal extends StatefulWidget {
  final Photos photo;

  EditModal(this.photo);

  @override
  _EditModalState createState() => _EditModalState();
}

class _EditModalState extends State<EditModal> {
  TextEditingController labelcontroller = TextEditingController();
  bool confirmable = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 600,
        child: Column(
          children: <Widget>[
            TextField(
              controller: labelcontroller,
              maxLength: 10,
              decoration: InputDecoration(hintText: 'Label'),
            ),
            RaisedButton(
              child: Text('Confirm'),
              onPressed: () async {
                try {
                  await FirestoreService().updatephoto(Photos(
                      label: labelcontroller.text,
                      uploader: widget.photo.uploader,
                      photourl: widget.photo.photourl,
                      id: widget.photo.id));
                } catch (e) {
                  print(e);
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
