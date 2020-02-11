class Photos {
  final String label;
  final String uploader;
  final String photourl;
  final String id;

  Photos({this.id, this.label, this.uploader, this.photourl});

  Photos.fromMap(Map<String, dynamic> data, String id)
      : label = data["label"],
        uploader = data["uploader"],
        photourl = data["photourl"],
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "label": label,
      "uploader": uploader,
      "photourl": photourl,
    };
  }
}
