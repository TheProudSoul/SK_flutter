import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_knowledge/bloc/bloc.dart';
import 'package:super_knowledge/common/file_model.dart';
import 'package:super_knowledge/utilities/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class Operations {
  static final api = Api();

  static void showNewFileDialog(BuildContext context, FileModel selectedItem) {
    String filename = 'untitled';
    String dirname = '';
    if (selectedItem != null) {
      if (selectedItem.leaf) {
        dirname = selectedItem.dirPath;
      } else {
        dirname = selectedItem.pathName + '/';
      }
    }
    Alert(
        closeFunction: () {
          print('close');
        },
        context: context,
        title: "Enter File Name",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.description),
              ),
              onChanged: (value) => filename = value,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => {
              Navigator.pop(context),
              api.addFile(dirname + filename + '.md').then((value) => {
                    if (value)
                      {
                        showSuccessDialog(
                            context, "New file name is " + filename)
                      }
                  })
            },
            child: Text("Commit",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          )
        ]).show();
  }

  static void showNewFolderDialog(
      BuildContext context, FileModel selectedItem) {
    String foldername = 'untitled';
    String dirname = '';
    if (selectedItem != null) {
      if (selectedItem.leaf) {
        dirname = selectedItem.dirPath;
      } else {
        dirname = selectedItem.pathName + '/';
      }
    }
    Alert(
        context: context,
        title: "Enter Folder Name",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.folder),
              ),
              onChanged: (value) => foldername = value,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => {
              Navigator.pop(context),
              api.addFolder(dirname + foldername).then((value) => {
                    if (value)
                      {
                        showSuccessDialog(
                            context, " New folder name is " + foldername)
                      }
                  })
            },
            child: Text(
              "Commit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  static void showRenameDialog(BuildContext context, FileModel selectedItem) {
    TextEditingController _renameController = TextEditingController();
    if (selectedItem.leaf) {
      _renameController.text =
          selectedItem.title.substring(0, selectedItem.title.indexOf('.'));
    } else {
      _renameController.text = selectedItem.title;
    }
    Alert(
        closeFunction: () => print('close rename dialog'),
        context: context,
        title: "Enter New Name",
        content: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              controller: _renameController, //设置controller
              decoration: InputDecoration(
                icon: Icon(Icons.text_fields),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              String newPath = selectedItem.leaf
                  ? _renameController.text + '.md'
                  : _renameController.text;
              if (selectedItem.dirPath != '') {
                newPath = selectedItem.dirPath + newPath;
              }
              api.move(selectedItem.pathName, newPath).then((value) => {
                    if (value)
                      {
                        showSuccessDialog(
                            context,
                            "${selectedItem.title} is moved to " +
                                newPath)
                      }
                  });
            },
            child: Text(
              "Commit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  static void showDeleteDialog(BuildContext context, FileModel selectedItem) {
    Alert(
      closeFunction: () => print('cancel delete.'),
      context: context,
      type: AlertType.warning,
      title: "DELETE",
      desc: "Are you sure?",
      buttons: [
        DialogButton(
          child: Text(
            "COMMIT",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => {
            api
                .deleteFile(selectedItem.pathName, !selectedItem.leaf)
                .then((value) => {
                      if (value)
                        {
                          Toast.show("删除成功！", context,
                              duration: Toast.LENGTH_SHORT, gravity: Toast.TOP),
                          Navigator.pop(context),
                          BlocProvider.of<FileSystemBloc>(context)
                              .add(FetchFileList())
                        }
                    })
          },
          width: 120,
        )
      ],
    ).show();
  }

  static void showSignupSuccessDialog(BuildContext context){
    Alert(
      context: context,
      type: AlertType.success,
      title: "Success",
      desc: 'You have successfully signed up.\nNow go log in.',
      buttons: [
        DialogButton(
          child:
          Text("COOL", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () => {
            Navigator.pop(context),
          },
          width: 120,
        )
      ],
    ).show();
  }

  static void showSuccessDialog(BuildContext context, String description) {
    Alert(
      closeFunction: ()=>print('close success dialog.'),
      context: context,
      type: AlertType.success,
      title: "Success",
      desc: description,
      buttons: [
        DialogButton(
          child:
              Text("COOL", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () => {
            Navigator.pop(context),
            BlocProvider.of<FileSystemBloc>(context).add(FetchFileList())
          },
          width: 120,
        )
      ],
    ).show();
  }

  static void showUnimplementedMessage(BuildContext context){
    Toast.show("该功能未完成！", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
  }
}
