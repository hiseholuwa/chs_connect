import 'package:flutter/material.dart';

class CardClipper extends CustomClipper<Path> {
  CardClipper();

  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(size.width * 0.25, 0.0);
    var controlPoint = Offset(size.width * 0.5, size.height * 0.125);
    var endPoint = Offset(size.width * 0.75, 0);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
