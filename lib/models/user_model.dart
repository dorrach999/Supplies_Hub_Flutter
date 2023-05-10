class Users {
  Users({required this.uid});

  final String uid;
}

class UsersData {
  final String uid;
  final String name;
  final String phone;
  final String sugars;

  UsersData({
    required this.uid,
    required this.name,
    required this.phone,
    required this.sugars,
  });
}
