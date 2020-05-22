import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_knowledge/common/file_model.dart';
import 'package:super_knowledge/common/operations.dart';
import 'package:toast/toast.dart';

class Editor extends StatefulWidget {
  final FileModel fileModel;
  final String initialMd;

  const Editor(this.fileModel, this.initialMd, {Key key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController _textEditingController;
  String text;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _textEditingController = new TextEditingController(text: widget.initialMd);
    text = widget.initialMd;
  }

  void _saveDocument(BuildContext context) {
    if (text != widget.initialMd) {
      Operations.api.saveFile(widget.fileModel.pathName, text).then((value) {
        if (value) {
          Toast.show("保存成功!", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
          Navigator.pop(context, true);
        }
      });
    } else {
      Toast.show("无需保存!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = new TextStyle(color: Colors.black);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: ()=>Navigator.pop(context)),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save, color: Colors.black),
              onPressed: () => {_saveDocument(context)},
            ),
          )
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.fileModel.title.substring(0, widget.fileModel.title.indexOf('.')), style: textStyle),
        bottom: TabBar(controller: _controller, tabs: <Widget>[
          Tab(child: Text('Editing', style: textStyle)),
          Tab(child: Text('Preview', style: textStyle))
        ]),
      ),
      body: TabBarView(
        controller: _controller,
          children: [
        Container(
          margin: EdgeInsets.all(20),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _textEditingController,
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (String text) {
              setState(() {
                this.text = text;
              });
            },
          ),
        ),
        SingleChildScrollView(
          child: Container(margin: EdgeInsets.all(20), child: MarkdownBody(data: text)),
        )
      ]),
    );
  }
}
