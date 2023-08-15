class User {
  final int? id;
  final String name;
  final String phone;
  final String access_token;
  final String? message;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.access_token,
    required this.message,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        phone: json['phone'],
        name: json['name'],
        id: json['id'],
        access_token: json['access_token'] == null ? "" : json["access_token"],
        message: json['data'] == null ? "" : json["data"]);
  }
}
