import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'dart:async';
import 'package:draw/draw.dart';

class ProfilePage extends StatefulWidget {
  @override
  const ProfilePage({Key key}) : super(key: key);

  _ProfilePage createState() => new _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  static String name;
  static String user;

  static var authUrl;

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

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) async{
          //print("onStateChanged: ${state.type} ${state.url}");
          tempCode=Uri.parse(state.url);
          print(tempCode.toString());
          print(tempCode.queryParameters['code']);

          await reddit.auth.authorize(tempCode.queryParameters['code']);

          // If everything worked correctly, we should be able to retrieve
          // information about the authenticated account.
          print(await reddit.user.me());

        });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.startsWith(configUri.toString())) {
            RegExp regExp = new RegExp("#access_token=(.*)");
            this.token = regExp.firstMatch(url)?.group(1);
            print("token $token");
            //saveToken(token);
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/home", (Route<dynamic> route) => false);
            flutterWebviewPlugin.close();
          }
        });
      }
    });
  }

 static final Uri configUri = Uri.parse("https://mojoman11.github.io/");
  static var reddit;

  Future<void> main() async{
    String userAgent;
    //TODO:Fix async to access userAgent before executing URL
    //await FlutterUserAgent.init(force: true);
    // userAgent = FlutterUserAgent.userAgent;
    // FlutterUserAgent.release();

    userAgent ="dartapp" ;

    print(userAgent);
    String clientId = "6ZvSitmYnojUdw";

    // Create a `Reddit` instance using a configuration file in the current
    // directory. Unlike the web authentication example, a client secret does
    // not need to be provided in the configuration file.
     reddit = Reddit.createInstalledFlowInstance(
        clientId: clientId, userAgent: userAgent, redirectUri: configUri);

    // Build the URL used for authentication. See `WebAuthenticator`
    // documentation for parameters.
    List<String> scopes = ["identity"];
    authUrl = reddit.auth.url(scopes, "abcd");
    print(authUrl.toString());


    // ...
    // Complete authentication at `authUrl` in the browser and retrieve
    // the `code` query parameter from the redirect URL.
    // ...

    // Assuming the `code` query parameter is stored in a variable
    // `auth_code`, we pass it to the `authorize` method in the
    // `WebAuthenticator`.
   // await reddit.auth.authorize(tempCode.queryParameters['code']);

   // // If everything worked correctly, we should be able to retrieve
   // // information about the authenticated account.
   // print(await reddit.user.me());
  }
  @override
  Widget build(BuildContext context) {
    main();

    return new WebviewScaffold(
        url: authUrl.toString(),
        appBar: new AppBar(
          title: new Text("Login to reddit..."),
        ));
  }

}
