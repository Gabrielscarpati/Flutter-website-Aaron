import 'package:flutter_website_aaron/app/framework/imodel.dart';

class User extends IModel {
  final int id;
  final int sellerId;
  final String email;

  User({
    required this.id,
    required this.sellerId,
    required this.email,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? -1,
      sellerId: json['seller_id'] ?? -1,
      email: json['email'] ?? '',
    );
  }

  factory User.empty() {
    return User(
      id: -1,
      sellerId: -1,
      email: '',
    );
  }
}
