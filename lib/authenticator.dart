import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:zeus_for_reddit/profile.dart';
import 'dart:async';
import 'package:draw/draw.dart';
import 'package:zeus_for_reddit/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticatorPage extends StatefulWidget {
  @override
  const AuthenticatorPage({Key key}) : super(key: key);

  _AuthenticatorPage createState() => new _AuthenticatorPage();


}

class _AuthenticatorPage extends State<AuthenticatorPage> {

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String token;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  static Uri tempCode;

  void initWebview(){
    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged = flutterWebviewPlugin.onStateChanged
        .listen((WebViewStateChanged state) async {
      //print("onStateChanged: ${state.type} ${state.url}");
      tempCode = Uri.parse(state.url);
      print(tempCode.toString());
      print(tempCode.queryParameters['code']);

        await ZFR.reddit.auth.authorize(tempCode.queryParameters['code']);

      if(ZFR.reddit.user.me()!=null){
        //TODO:remove to write
        //await writeCredentials(ZFR.reddit.auth.credentials.toJson());
        print("WROTE SUCESSFULLY");
        Navigator.pop(context,true);
      }else{
        Navigator.pop(context,false);
      }

    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print("Url changed");
      //flutterWebviewPlugin.close();
    });

  }

  @override
  void initState() {

    initWebview();
    print("Before BUILDING");
    print("useragent ${ZFR.userAgent}");
    super.initState();

  }


  Future<void> writeCredentials (String credentials)async{
    final prefs = await SharedPreferences.getInstance();
     await prefs.setString('credentials', credentials);
  }

  @override
  Widget build(BuildContext context) {
    print("BUilding Now");
    return new WebviewScaffold(
        url: ZFR.authUrl.toString(),
        appBar: new AppBar(
          title: new Text("Login to reddit..."),
        ));
  }
}
