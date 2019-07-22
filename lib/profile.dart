import 'package:flutter/material.dart';
import 'package:zeus_for_reddit/authenticator.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:zeus_for_reddit/main.dart';
import 'package:csv/csv.dart';
class ProfilePage extends StatefulWidget {



  @override
  const ProfilePage({Key key}) : super(key: key);
  _ProfilePage createState() => new _ProfilePage();

}

class _ProfilePage extends State<ProfilePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () async {
              bool loginSuccess=
                  await Navigator.push(
                context,
                MaterialPageRoute<bool>(builder: (context) => AuthenticatorPage()),
              );
              print(loginSuccess);

              if(loginSuccess){
                 print(await ZFR.reddit.user.scopes());

                //List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(redditor);

                //Scaffold.of(context).showSnackBar(new SnackBar(content: Text(await ZFR.reddit.user.me())));
              }
            },
            child: const Text(
                'Login to Reddit',
                style: TextStyle(fontSize: 20)
            ),
          ),
    ])));
  }
}
