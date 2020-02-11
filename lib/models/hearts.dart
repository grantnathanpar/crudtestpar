class Hearts {
  final String email;
  final String id;

  Hearts({this.id, this.email});

  Hearts.fromMap(Map<String, dynamic> data, String id)
      : email = data["email"],
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "email": email,
    };
  }
}
