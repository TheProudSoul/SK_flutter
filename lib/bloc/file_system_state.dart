import 'package:equatable/equatable.dart';
import 'package:super_knowledge/common/file_model.dart';

abstract class FileSystemState extends Equatable {
  const FileSystemState([List props = const []]);

  @override
  List<Object> get props => [];
}

class FileSystemEmpty extends FileSystemState {}

class FileSystemLoading extends FileSystemState {}

class FileSystemError extends FileSystemState {}

class FileSystemReloaded extends FileSystemState {}

class FileSystemLoaded extends FileSystemState {
  final List<FileModel> fileList;

  FileSystemLoaded(this.fileList);

  @override
  List<Object> get props => [fileList];
}
