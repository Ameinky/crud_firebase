class Voking {
  String? name;
  String? email;

  Voking.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
  }
}
