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
import 'package:zeus_for_reddit/authenticator.dart';
import 'search.dart';
import 'profile.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:draw/draw.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';


void main() => runApp(ZFR());
/// This Widget is the main application widget.
class ZFR extends StatelessWidget {
  static var reddit;
  static Uri authUrl;
  static final Uri configUri = Uri.parse("https://mojoman11.github.io/");
  static String userAgent;


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
  void initState(){
    getUserAgent();
   // sleep(new Duration(seconds: 4));
    initReddit();
    super.initState();
  }



static Future<void> initReddit()async{
  //TODO: return -1 for error?
  String userAgent = ZFR.userAgent;
  String clientId = "6ZvSitmYnojUdw";
  print("B4 the LOAD");
  var credentialsJson =  await loadCredentials();
  print("B4 the IF");
  print(credentialsJson.toString());
  //TODO:PR for no type for credentialsJson
  if(credentialsJson==null) {
    print("in the IF");
    ZFR.reddit = Reddit.createInstalledFlowInstance(
        clientId: clientId, userAgent: ZFR.userAgent, redirectUri: ZFR.configUri);
    List<String> scopes = ["identity","mysubreddits","flair","read","history"];
    //TODO: change the random string and verify
    ZFR.authUrl = ZFR.reddit.auth.url(scopes, "abcd");
    print('authURL done ${ZFR.authUrl.toString()}');

  }else{
    print("IN ELSE");
    ZFR.reddit = Reddit.restoreAuthenticatedInstance(credentialsJson.toString(),clientId:clientId,userAgent: ZFR.userAgent,configUri: ZFR.configUri);
   print("Client restored!");
  }
}

static Future<String> loadCredentials ()async{
  final prefs = await SharedPreferences.getInstance();
  String a =prefs.getString('credentials') ?? null;
  print(a);
  return a;
}

  Future<void> getUserAgent()async{
    await FlutterUserAgent.init();
    ZFR.userAgent=FlutterUserAgent.userAgent;
    print(ZFR.userAgent);
    FlutterUserAgent.release();
  }

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
