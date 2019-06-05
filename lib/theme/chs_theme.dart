import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';
export 'package:chs_connect/theme/component/chs_theme_widgets.dart';

class Theme extends StatefulWidget {
  final ChsThemeModel model;
  final Widget Function(BuildContext, ChsThemeModel) builder;

  const Theme({
    Key key,
    @required this.model,
    @required this.builder,
  }) : super(key: key);

  @override
  _ThemeState createState() => _ThemeState();
}

class _ThemeState extends State<Theme>
{
  ChsThemeModel _themeModel;
  void _init() async {
    try {
      _themeModel = widget.model..init();
    } catch (e) {}
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(Theme oldWidget) {
    if (oldWidget.model != widget.model) {
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ChsThemeModel>(
      builder: (_) => _themeModel,
      child: Consumer<ChsThemeModel>(
        builder: (context, model, child) => widget.builder(context, model),
      ),
    );
  }
}