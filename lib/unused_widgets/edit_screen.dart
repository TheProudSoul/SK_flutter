import 'package:notus/convert.dart';
import 'package:flutter/material.dart';
import 'package:super_knowledge/common/file_model.dart';
import 'package:super_knowledge/utilities/api.dart';
import 'package:toast/toast.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

class EditScreen extends StatefulWidget {
  final FileModel _fileModel;
  final String _markdownText;

  const EditScreen(this._fileModel, this._markdownText, {Key key})
      : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  final api = Api();

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();

  }

  @override
  void dispose() {
    super.dispose();
  }

  // change: add after _loadDocument()
  void _saveDocument(BuildContext context) {
    final content = notusMarkdown.encode(_controller.document.toDelta());
    print(content);
    print(widget._markdownText);
    if (content != widget._markdownText) {
      api.saveFile(widget._fileModel.pathName, content).then((value) {
        if (value) {
          Toast.show("保存成功!", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
        }
      });
    } else {
      Toast.show("无需保存!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
    }
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final Delta delta = Delta()..insert(widget._markdownText)..insert('\n');
    return NotusDocument.fromDelta(delta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF61A4F1),
        title: Text(widget._fileModel.title),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => {_saveDocument(context)},
            ),
          )
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }
}
