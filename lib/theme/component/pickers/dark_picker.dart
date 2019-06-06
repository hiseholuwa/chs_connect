import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class DarkColorPicker extends StatefulWidget {
  const DarkColorPicker({
    this.onChanged,
    @required this.value,
  });

  final ValueChanged<Color> onChanged;
  final Color value;

  @override
  _DarkColorPickerState createState() => _DarkColorPickerState();
}

class _DarkColorPickerState extends State<DarkColorPicker> {
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
      onMainColorChange: (ColorSwatch color) {
        if (mounted)
          setState(() {
            main = color;
          });
      },
      onColorChange: (color) => widget.onChanged(color),
      colors: [
        Colors.redAccent,
        Colors.pinkAccent,
        Colors.purpleAccent,
        Colors.deepPurpleAccent,
        Colors.blueAccent,
        Colors.greenAccent,
        Colors.amberAccent,
        Colors.cyanAccent,
        Colors.deepOrangeAccent,
        Colors.indigoAccent,
        Colors.lightBlueAccent,
        Colors.lightGreenAccent,
        Colors.limeAccent,
        Colors.orangeAccent,
        Colors.tealAccent,
        Colors.yellowAccent,
        Colors.brown,
        Colors.blueGrey
      ],
    );
  }
}