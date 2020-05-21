import 'package:flutter/material.dart';
import 'package:justwriteit/common/file_model.dart';
import 'package:justwriteit/screens/preview_screen.dart';
import 'package:justwriteit/utilities/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final api = new Api();

class FileEntryItem extends StatefulWidget {
  final FileModel _fileModel;

  const FileEntryItem(this._fileModel);
  @override
  _FileEntryItemState createState() => _FileEntryItemState();
}

class _FileEntryItemState extends State<FileEntryItem> {
  FileModel _selectedItem;

  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(BuildContext context, FileModel root) {
    if (root.leaf) {
      return ListTile(
        title: Text(root.title),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<Null>(
              builder: (BuildContext context) => PreviewScreen(root))).then((value) => {
                if(value){

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
    return ExpansionTile(
      key: PageStorageKey<FileModel>(root),
      title: Text(root.title),
      children:
          root.children.map<Widget>((e) => _buildTiles(context, e)).toList(),
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
            height: 180,
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
          String _fileName;
          String _dirName;
          if (_selectedItem.leaf) {
            _dirName = _selectedItem.dirPath + '/';
          } else {
            _dirName = _selectedItem.pathName + '/';
          }

          Alert(
              context: context,
              title: "Enter File Name",
              content: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.description),
                    ),
                    onChanged: (value) => _fileName = value,
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () => {
                    Navigator.pop(context),
                    api.addFile(_dirName + _fileName + '.md').then((value) => {
                          if (value)
                            {
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Success",
                                desc: " New file name is " + _fileName,
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "COOL",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => {
                                      CategoryScreen,
                                      Navigator.pop(context),
                                    },
                                    width: 120,
                                  )
                                ],
                              ).show()
                            }
                        })
                  },
                  child: Text(
                    "Commit",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
          break;
        }
      case ('new folder'):
        {
          Alert(
              context: context,
              title: "Enter Folder Name",
              content: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.folder),
                    ),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: Text(
                    "Commit",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
          break;
        }
      case ('delete'):
        {
          Alert(context: context, title: "delete", desc: "Flutter is awesome.")
              .show();

          break;
        }
    }
  }
}

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List _fileList = [];

  void getData() {
    api.fileSystem().then((value) {
      setState(() {
        _fileList = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
        backgroundColor: Color(0xFF61A4F1),
      ),
      body: ListView.builder(
          itemCount: _fileList.length,
          itemBuilder: (BuildContext context, int index) =>
              FileEntryItem(FileModel.fromJson(_fileList[index]))),
    );
  }
}
