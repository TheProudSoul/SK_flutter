import 'package:equatable/equatable.dart';

class FileModel extends Equatable{
  final String title;
  final bool leaf;
  final String dirPath;
  final String pathName;
  final List<FileModel> children;

  FileModel(this.title, this.leaf, this.dirPath, this.pathName, [this.children = const <FileModel>[]]);
//
//  FileModel.fromJson(Map jsonMap)
//      : assert(jsonMap['title'] != null),
//        assert(jsonMap['dirPath'] != null),
//        assert(jsonMap['pathName'] != null),
//        assert(jsonMap['leaf'] != null),
//        title = jsonMap['title'],
//        dirPath = jsonMap['dirPath'],
//        pathName = jsonMap['pathName'],
//        leaf = jsonMap['leaf'],
//        children = jsonMap['children']!=null ? jsonMap['children'].map<FileModel>((e)=>FileModel.fromJson(e)).toList():<FileModel>[];

  factory FileModel.fromJson(Map<String, dynamic> jsonMap){
    return FileModel(jsonMap['title'],jsonMap['leaf'],jsonMap['dirPath'],jsonMap['pathName'],jsonMap['children']!=null ? jsonMap['children'].map<FileModel>((e)=>FileModel.fromJson(e)).toList():<FileModel>[]);
  }

  @override
  List<Object> get props => [title, leaf, dirPath, pathName, children];

  @override
  bool get stringify => true;

}