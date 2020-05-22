import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justwriteit/bloc/bloc.dart';
import 'package:justwriteit/common/file_entry_item.dart';
import 'package:justwriteit/common/file_model.dart';
import 'package:justwriteit/screens/loading.dart';
import 'package:justwriteit/utilities/api.dart';
import 'package:justwriteit/utilities/constants.dart';

import '../common/operations.dart';

final api = new Api();

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    BlocProvider.of<FileSystemBloc>(context).add(FetchFileList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Category'),
          backgroundColor: mainColor,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.note_add),
                onPressed: () => Operations.showNewFileDialog(context, null)),
            IconButton(
                icon: Icon(Icons.create_new_folder),
                onPressed: () => Operations.showNewFolderDialog(context, null)),
          ],
        ),
        body: BlocConsumer<FileSystemBloc, FileSystemState>(
            listener: (context, state) {
          if (state is FileSystemReloaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        }, builder: (BuildContext context, FileSystemState state) {
          if (state is FileSystemLoaded) {
            return buildListWithData(state.fileList);
          } else {
            return Loading();
          }
        }),
//        floatingActionButton: FloatingActionButton(
//          onPressed: () => Navigator.push(
//              context,
//              MaterialPageRoute<Null>(
//                  builder: (BuildContext context) => Dashboard())),
//        )
    );
  }

  Widget buildListWithData(List<FileModel> fileList) {
    return RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<FileSystemBloc>(context).add(RefreshFileList());
          return _refreshCompleter.future;
        },
        child: ListView.builder(
            itemCount: fileList.length,
            itemBuilder: (BuildContext context, int index) =>
                FileEntryItem(fileList[index])));
  }
}
