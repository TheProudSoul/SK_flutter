import 'package:equatable/equatable.dart';

abstract class FileSystemEvent extends Equatable {
  const FileSystemEvent();
}

class FetchFileList extends FileSystemEvent{
  @override
  List<Object> get props => [];

}

class RefreshFileList extends FileSystemEvent {
  @override
  List<Object> get props => [];
}