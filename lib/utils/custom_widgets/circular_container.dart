import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularContainer extends StatelessWidget {
  final double size;
  final Color color;
  final String? image;

  const CircularContainer({
    Key? key,
    this.size = 50.0,
    this.color = primaryColor, // Default color is blue
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding:  EdgeInsets.all(MySize.size13),
        child: SvgPicture.asset(image!),
      ),
    );
  }
}
