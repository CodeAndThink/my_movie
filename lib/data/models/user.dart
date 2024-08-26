class User {
  final String id;
  final String email;
  final String displayName;
  final String dob;
  final int gender;
  final String phone;
  final String address;
  final String password;
  final String avatarPath;
  final String createDate;
  final List<int> favoritesList;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.address,
    required this.password,
    required this.avatarPath,
    required this.createDate,
    required this.favoritesList,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      dob: json['dob'],
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      password: json['password'],
      avatarPath: json['avatarPath'],
      createDate: json['createDate'],
      favoritesList: List<int>.from(json['favoritesList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'address': address,
      'password': password,
      'avatarPath': avatarPath,
      'createDate': createDate,
      'favoritesList': favoritesList,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, displayName: $displayName, dob: $dob, gender: $gender, phone: $phone, address: $address, password: $password, avatarPath: $avatarPath, createDate: $createDate, favoritesList: $favoritesList}';
  }
}
