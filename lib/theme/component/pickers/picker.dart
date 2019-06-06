import 'package:chs_connect/constants/chs_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    this.onChanged,
    @required this.value,
  });

  final ValueChanged<Color> onChanged;
  final Color value;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color main;

  @override
  void initState() {
    main = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialColorPicker(
      selectedColor: main,
      onMainColorChange: (color) => setState(() => main = color),
      onColorChange: (color) => setState(() => widget.onChanged(color)),
      colors: [
        Colors.red,
        Colors.redAccent,
        Colors.pink,
        Colors.pinkAccent,
        Colors.purple,
        Colors.purpleAccent,
        Colors.deepPurple,
        Colors.deepPurpleAccent,
        Colors.blue,
        Colors.blueAccent,
        Colors.green,
        Colors.greenAccent,
        Colors.amber,
        Colors.amberAccent,
        Colors.cyan,
        Colors.cyanAccent,
        Colors.deepOrange,
        Colors.deepOrangeAccent,
        Colors.indigo,
        Colors.indigoAccent,
        Colors.lightBlue,
        Colors.lightBlueAccent,
        Colors.lightGreen,
        Colors.lightGreenAccent,
        Colors.lime,
        Colors.limeAccent,
        Colors.orange,
        Colors.orangeAccent,
        Colors.teal,
        Colors.tealAccent,
        Colors.yellow,
        Colors.yellowAccent,
        Colors.brown,
        Colors.blueGrey,
        ChsColors.white,
        ChsColors.black
      ],
    );
  }
}