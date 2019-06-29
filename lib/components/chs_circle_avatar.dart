import 'package:chs_connect/constants/chs_colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChsCircleAvatar extends StatelessWidget {
  final double radius;
  final String src;
  final AnimationController controller;

  ChsCircleAvatar({this.src, this.radius, this.controller});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      src,
      height: radius,
      width: radius,
      fit: BoxFit.fill,
      cache: true,
      border: Border.all(color: ChsColors.default_accent, width: 1.0),
      shape: BoxShape.circle,
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            controller.reset();
            return CircularProgressIndicator();
            break;
          case LoadState.completed:
            controller.forward();
            return FadeTransition(
              opacity: controller,
              child: ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: radius,
                height: radius,
                fit: BoxFit.cover,
              ),
            );
            break;
          case LoadState.failed:
            controller.reset();
            state.imageProvider.evict();
            return GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
            );
            break;
        }
      },
    );
  }
}
