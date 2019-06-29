import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  ChsThemeModel theme;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    theme = Provider.of<ChsThemeModel>(context);
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.theme.appBarTheme.color,
          title: Text(
            "FlushBar",
            style: theme.theme.textTheme.display1,
          ),
          elevation: theme.theme.appBarTheme.elevation,
        ),
        body: buildFeed(deviceSize),
      ),
    );
  }

  Widget buildFeed(Size deviceSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text("Click Me!!!!!"),
            onPressed: () {
              Flushbar(
                messageText: Text("Hello From the other side", style: TextStyle(color: theme.darkMode ? Colors.black : Colors.white),),
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                aroundPadding: EdgeInsets.all(8),
                borderRadius: 8,
                backgroundColor: theme.darkMode ? Colors.white : ChsColors.dark_bkg,
                duration: Duration(seconds: 3),
              )
                ..show(context);
            },
          ),
        ],
      ),
    );
  }
}
