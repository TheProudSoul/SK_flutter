import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justwriteit/bloc/bloc.dart';
import 'package:justwriteit/bloc/file_system_bloc.dart';
import 'package:justwriteit/screens/preview_screen.dart';
import 'package:justwriteit/utilities/api.dart';
import 'operations.dart';
import 'file_model.dart';

class FileEntryItem extends StatefulWidget {
  final FileModel _fileModel;

  const FileEntryItem(this._fileModel);
  @override
  _FileEntryItemState createState() => _FileEntryItemState();
}

class _FileEntryItemState extends State<FileEntryItem> {
  FileModel _selectedItem;
  final api = new Api();

  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(BuildContext context, FileModel root) {
    if (root.leaf) {
      return ListTile(
        leading: Icon(Icons.bookmark_border),
        title: Text(root.title),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (BuildContext context) => PreviewScreen(root)))
              .then((value) => {
                    if (value != null)
                      {
                        BlocProvider.of<FileSystemBloc>(context)
                            .add(FetchFileList())
                      }
                  });
        },
        onLongPress: () {
          setState(() {
            _selectedItem = root;
          });
          _onLongPressed();
        },
      );
    }
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _selectedItem = root;
        });
        _onLongPressed();
      },
      child: ExpansionTile(
        leading: Icon(Icons.folder_open),
        key: PageStorageKey<FileModel>(root),
        title: Text(root.title),
        children:
            root.children.map<Widget>((e) => _buildTiles(context, e)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(context, widget._fileModel);
  }

  void _onLongPressed() {
    showModalBottomSheet(
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 240,
            child: Container(
              child: _buildBottomNavigationMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        },
        context: context);
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.note_add,
            color: Colors.blueGrey,
          ),
          title: Text('New File'),
          onTap: () => _selectItem('new file'),
        ),
        ListTile(
          leading: Icon(
            Icons.create_new_folder,
            color: Colors.blueGrey,
          ),
          title: Text('New Folder'),
          onTap: () => _selectItem('new folder'),
        ),
        ListTile(
          leading: Icon(
            Icons.create,
            color: Colors.blueGrey,
          ),
          title: Text('Rename'),
          onTap: () => _selectItem('rename'),
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text('Delete'),
          onTap: () => _selectItem('delete'),
        ),
      ],
    );
  }

  void _selectItem(String name) {
    Navigator.pop(context);
    switch (name) {
      case ('new file'):
        {
          Operations.showNewFileDialog(context, _selectedItem);
          break;
        }
      case ('new folder'):
        {
          Operations.showNewFolderDialog(context, _selectedItem);
          break;
        }
      case ('rename'):
        {
          Operations.showRenameDialog(context, _selectedItem);
          break;
        }
      case ('delete'):
        {
          Operations.showDeleteDialog(context, _selectedItem);
          break;
        }
    }
  }
}
