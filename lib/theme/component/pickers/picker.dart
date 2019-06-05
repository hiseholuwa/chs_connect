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
      allowShades: true,
      onMainColorChange: (ColorSwatch color) {
        if (mounted)
          setState(() {
            main = color;
          });
      },
      onColorChange: (color) => widget.onChanged(color),
    );
  }
}