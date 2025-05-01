import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isEmailVerified;

  const User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.isEmailVerified = false});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email
      };

  User copyWith(
      {String? firstName,
      String? lastName,
      String? email,
      bool? isEmailVerified}) {
    return User(
        id: id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified);
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, isEmailVerified];
}
