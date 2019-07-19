import 'package:flutter/material.dart';

class NewPostPage extends StatefulWidget {
  @override
  NewPostPage ({Key key}) : super(key: key);

  _NewPostPageState createState() => new _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New create page'),
      ),
    );
  }
}