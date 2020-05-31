class UserModel {
  static int _userId=0;
  static String _username='';
  static String _email='';
  static String _token='';

  static int get userId => _userId;
  static String get username => _username;
  static String get email => _email;
  static String get token => _token;

  static setToken(int userId, String token) {
    _userId = userId;
    _token = token;
  }

  static setUserInfo(String username, String email) {
    _username = username;
    _email = email;
  }
}
