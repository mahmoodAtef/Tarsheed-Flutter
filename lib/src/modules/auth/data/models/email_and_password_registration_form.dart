class EmailAndPasswordRegistrationForm {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const EmailAndPasswordRegistrationForm(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName});

  factory EmailAndPasswordRegistrationForm.fromJson(Map<String, dynamic> json) {
    return EmailAndPasswordRegistrationForm(
        email: json['email'],
        password: json['password'],
        firstName: json['first_name'],
        lastName: json['last_name']);
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName
      };
}
