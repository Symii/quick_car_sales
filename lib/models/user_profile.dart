class UserProfile {
  String name;
  String surname;
  String address;
  String email;

  UserProfile({
    required this.name,
    required this.surname,
    required this.address,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'address': address,
      'email': email,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      surname: map['surname'],
      address: map['address'],
      email: map['email'],
    );
  }
}
