import 'package:flutter_colorpicker/material_picker.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  ChsThemeModel theme;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);


  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

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
            "Color Picker",
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
            child: Text("Click"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>  AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
//                    child: ColorPicker(
//                      pickerColor: pickerColor,
//                      onColorChanged: changeColor,
//                      enableLabel: true,
//                      pickerAreaHeightPercent: 0.8,
//                    ),
                    // Use Material color picker:
                    //
                     child: MaterialPicker(
                       pickerColor: pickerColor,
                       onColorChanged: changeColor,
                      // enableLabel: true, // only on portrait mode
                     ),
                    //
                    // Use Block color picker:
                    //
                    // child: BlockPicker(
                    //   pickerColor: currentColor,
                    //   onColorChanged: changeColor,
                    // ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('OK'),
                      onPressed: () {
                        setState(() => currentColor = pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
