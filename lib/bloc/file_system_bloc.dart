import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:super_knowledge/common/file_model.dart';
import 'package:super_knowledge/utilities/api.dart';
import './bloc.dart';

class FileSystemBloc extends Bloc<FileSystemEvent, FileSystemState> {

  final api = Api();
  @override
  FileSystemState get initialState => FileSystemEmpty();

  @override
  Stream<FileSystemState> mapEventToState(
    FileSystemEvent event,
  ) async* {
    if(event is FetchFileList){
      yield* _mapFetchFileListToState(event);
    }else if (event is RefreshFileList) {
      yield* _mapRefreshFileListToState(event);
    }
  }


  Stream<FileSystemState> _mapFetchFileListToState(FetchFileList event) async* {
    yield FileSystemLoading();
    try {
      final List<FileModel> fileList =await api.fileSystem();
      yield FileSystemLoaded(fileList);
    } catch (_) {
      yield FileSystemError();
    }
  }

  Stream<FileSystemState> _mapRefreshFileListToState(RefreshFileList event) async* {
    try {
      final List<FileModel> fileList = await api.fileSystem();
      yield FileSystemReloaded();
      yield FileSystemLoaded(fileList);
    } catch (_) {
      yield state;
    }
  }
}