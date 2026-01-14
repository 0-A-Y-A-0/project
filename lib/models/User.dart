class User {
  String first_name;
  String last_name;
  DateTime birth_date;
  String photo_url;
  String doc_url;
  String phone;
  String? token;
  String? bio;
  int? id;

  User({required this.first_name, required this.last_name,
    required this.birth_date, required this.photo_url,
    required this.doc_url, required this.phone,
    this.token = null, this.bio = "Hi, I'm using", this.id = 0
  });

  void setToken(String? newToken) {
    token = newToken;
  }

  String getPhone(){
    return phone;
  }
}