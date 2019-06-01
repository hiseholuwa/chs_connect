import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
//    final bloc = MainProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          ChsStrings.appName,
          style: TextStyle(
              fontFamily: "Rochester",
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 35),
        ),
        elevation: 4,
      ),
      body: buildFeed(deviceSize),
    );
  }

  Widget buildFeed(Size deviceSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: deviceSize.height * 0.15,
            child: Image.asset(ChsImages.no_content),
          ),
          SizedBox(
            height: deviceSize.height * 0.02,
          ),
          Text(
            ChsStrings.no_feed,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: "WorkSans"),
          )
        ],
      ),
    );
  }
}
