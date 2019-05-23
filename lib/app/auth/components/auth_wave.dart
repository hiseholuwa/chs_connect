import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class AuthWave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: WaveWidget(
        config: CustomConfig(
          colors: [
            Colors.black38,
            Colors.black26,
            Colors.black12,
            Colors.grey[800],
          ],
          durations: [35000, 19440, 10800, 6000],
          heightPercentages: [0.10, 0.20, 0.30, 0.40],
          blur: MaskFilter.blur(BlurStyle.solid, 10),
        ),
        waveAmplitude: 0,
        size: Size(deviceSize.width, deviceSize.height / 10),
      ),
    );
  }
}
