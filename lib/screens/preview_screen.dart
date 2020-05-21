import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:justwriteit/common/file_model.dart';
import 'package:justwriteit/screens/loading.dart';
import 'package:justwriteit/utilities/api.dart';
import 'package:toast/toast.dart';

import 'edit_screen.dart';

class PreviewScreen extends StatefulWidget {
  final FileModel _fileModel;

  PreviewScreen(this._fileModel);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  String markdownText;
  final api = Api();
  bool loading = true;

  void getData() {
    api.readFile(widget._fileModel.pathName).then((value) {
      if(value!=null){
        setState(() {
          markdownText = value;
        });
      }
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List _buildAppbarActions() {
    return <Widget>[
      PopupMenuButton(
        onSelected: (value) {
          if (value == 'edit') {
            Navigator.of(context).push(MaterialPageRoute<Null>(
                builder: (BuildContext context) =>
                    EditScreen(widget._fileModel, markdownText)));
          } else {
            api.deleteFile(widget._fileModel.pathName, false).then((value) {
              if(value){
                Toast.show("删除成功！", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
                Navigator.pop(context, true);
              }
            });
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'edit',
            child: Row(children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                  child: Icon(
                    Icons.edit,
                    color: Colors.blueGrey,
                  )),
              Text('Edit')
            ]),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              Text('Delete')
            ]),
          ),
        ],
        offset: Offset(0, 100),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      appBar: AppBar(
        title: Text(widget._fileModel.title),
        backgroundColor: Color(0xFF61A4F1),
        actions: _buildAppbarActions(),
      ),
      body: Markdown(
        data: markdownText,
      ),
    );
  }
}
