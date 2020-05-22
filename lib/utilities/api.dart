import 'package:dio/dio.dart';
import 'package:super_knowledge/common/file_model.dart';
import 'package:super_knowledge/common/user_model.dart';

class Api {
  Dio dio;
  final String successCode = '00';

  Api(){
    BaseOptions options = new BaseOptions(
        baseUrl: "http://47.115.40.131:9999",
        connectTimeout: 5000,
        receiveTimeout: 3000,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json);
    dio = new Dio(options);
    dio.interceptors.add(CustomInterceptors());
  }

  /// 登录
  Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post('/account/login',
          data: {'username': username, 'password': password});
      final responseBody = response.data;
      print(responseBody);
      if (responseBody['errCode'] != successCode) {
        return false;
      }
      UserModel.setUserInfo(responseBody['data']['id'],
          responseBody['data']['username'], responseBody['data']['email']);
      return true;
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  /// 注册
  Future<bool> signup(String email, String username, String password, String confirmPassword) async {
    try {
      final response = await dio.post('/account/registration',
          data: {'email': email, 'username': username, 'password': password, 'confirmPassword': confirmPassword});
      final responseBody = response.data;
      if (responseBody['errCode'] != successCode) {
        return false;
      }
      return true;
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  /// category
  Future<List<FileModel>> fileSystem() async {
    try {
      final response = await dio.get('/api/file-system/${UserModel.userId}');
      final responseBody = response.data;
      if (responseBody['errCode'] != successCode) {
        return null;
      }
      List fileList = responseBody['data'];
      return fileList.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  /// 读取文件内容
  Future<String> readFile(String pathname) async {
    try {
      final response = await dio
          .get('/api/file-system/${UserModel.userId}/file?path=$pathname');
      final responseBody = response.data;
      if (responseBody['errCode'] != successCode) {
        return null;
      }
      return responseBody['data'];
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  /// 保存文件
  Future<bool> saveFile(String pathname, String content) async {
    try {
      final response = await dio.post('/commit-edit', data: {
        "userId": UserModel.userId,
        'path': pathname,
        "data": content
      });
      final responseBody = response.data;
      if (responseBody['errCode'] != successCode) {
        return false;
      }
      return true;
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  /// 删除文件
  Future<bool> deleteFile(String pathname, bool dir) async {
    try {
      final response = await dio.post('/commit-delete',
          data: {"userId": UserModel.userId, 'path': pathname, "dir": dir});
      final responseBody = response.data;
      if (responseBody['errCode'] != successCode) {
        return false;
      }
      return true;
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  /// 添加文件
  Future<bool> addFile(String pathname) async {
    try {
      final response = await dio.post('/commit-add',
          data: {"userId": UserModel.userId, 'path': pathname, "dir": false});
      final responseBody = response.data;
      if (responseBody['errCode'] != successCode) {
        return false;
      }
      return true;
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  /// 添加文件夹
  Future<bool> addFolder(String pathname) async {
    try {
      final response = await dio.post('/commit-add',
          data: {"userId": UserModel.userId, 'path': pathname, "dir": true});
      final responseBody = response.data;
      if (responseBody['errCode'] != successCode) {
        return false;
      }
      return true;
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  /// 移动
  Future<bool> move(String oldPath, String newPath) async {
    try {
      final response = await dio.post('/commit-move',
          data: {"userId": UserModel.userId, 'path': oldPath, "data": newPath});
      final responseBody = response.data;
      if (responseBody['errCode'] != successCode) {
        return false;
      }
      return true;
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    print("REQUEST[${options?.method}] => PATH: ${options?.path}");
    return super.onRequest(options);
  }
  @override
  Future onResponse(Response response) {
    print("RESPONSE[${response?.statusCode}] => DATA: ${response?.data}");
    return super.onResponse(response);
  }
  @override
  Future onError(DioError err) {
    print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    return super.onError(err);
  }
}