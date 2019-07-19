import 'package:flutter/material.dart';
class SearchPage extends StatefulWidget {
  @override
  const SearchPage({Key key}) : super(key: key);

  _SearchPage createState() => new _SearchPage();

}

class _SearchPage extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search page'),
      ),
    );
  }
}
