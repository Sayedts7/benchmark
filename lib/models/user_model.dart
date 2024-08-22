class UserData {
  DateTime? deleteTime;
  String email;
  String id;
  bool isDeleted;
  String name;
  String password;
  String phone;
  String signUpWith;
  String status;
  bool verified;

  UserData({
    this.deleteTime,
    required this.email,
    required this.id,
    required this.isDeleted,
    required this.name,
    required this.password,
    required this.phone,
    required this.signUpWith,
    required this.status,
    required this.verified,
  });

  // Factory constructor to create an instance from a JSON map
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      deleteTime: json['deleteTime'] != null ? DateTime.parse(json['deleteTime']) : null,
      email: json['email'],
      id: json['id'],
      isDeleted: json['isDeleted'],
      name: json['name'],
      password: json['password'],
      phone: json['phone'],
      signUpWith: json['signUpWith'],
      status: json['status'],
      verified: json['verified'],
    );
  }

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'deleteTime': deleteTime?.toIso8601String(),
      'email': email,
      'id': id,
      'isDeleted': isDeleted,
      'name': name,
      'password': password,
      'phone': phone,
      'signUpWith': signUpWith,
      'status': status,
      'verified': verified,
    };
  }
}
