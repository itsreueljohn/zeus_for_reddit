// Flutter code sample for material.BottomNavigationBar.1

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'package:zeus_for_reddit/feed.dart';
import 'package:zeus_for_reddit/create.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'search.dart';
import 'profile.dart';

void main() => runApp(ZFR());
/// This Widget is the main application widget.
class ZFR extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: MainWidget(),
      );
  }
}

class MainWidget extends StatefulWidget{
  @override
  _MainWidgetState createState() => _MainWidgetState();

}

class _MainWidgetState extends State<MainWidget> {

  final List<Widget> pageKeys = [
    HomePage(
      key: PageStorageKey('Page1'),
    ),
    SearchPage(
        key: PageStorageKey('Page2')
    ),
    NewPostPage(
      key: PageStorageKey('Page3'),
    ),
    ProfilePage(
      key: PageStorageKey('Page4'),
    )
  ];

  final List pages = [HomePage(),SearchPage(), NewPostPage(), ProfilePage()];
  Widget currentPage = HomePage();
  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  PageStorage(child: currentPage, bucket: bucket),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.rss_feed),
              title: Text('Feed'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              title: Text('New'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.face),
              title: Text('Profile'),
            ),
          ],
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: (i) {
            setState(() {
              _selectedIndex = i;
              currentPage = pages[i];
            });
          },
        ));
  }
}
