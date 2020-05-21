class UserModel {
  static int _userId;
  static String _username;
  static String _email;

  static int get userId => _userId;
  static String get username => _username;
  static String get email => _email;

  static setUserInfo(int userId, String username, String email) {
    _userId = userId;
    _username = username;
    _email = email;
  }
}
