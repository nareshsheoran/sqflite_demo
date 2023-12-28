class UserModel {
  int? id;
  final String name;
  final String email;
  final int age;
  final String mobileNumber;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.mobileNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      mobileNumber: json['mobileNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'mobileNumber': mobileNumber,
    };
  }
}
