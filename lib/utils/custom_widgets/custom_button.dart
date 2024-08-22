
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/MySize.dart';
import '../constants/colors.dart';
import '../constants/textStyles.dart';

class CustomButton8 extends StatelessWidget {
  final String text;
  final double width;
  final double height;

  final Color? textColor;
  final double radius;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  const CustomButton8({
    super.key,
    required this.text,
    this.width = double.infinity,
    this.height = 55,
    this.backgroundColor = primaryColor,
    required this.onPressed,
    this.textColor,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          backgroundColor: backgroundColor,
          disabledBackgroundColor: Colors.grey[300],
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style:  AppTextStyles.label16600W,

        ),
      ),
    );
  }
}


class CustomBorderedButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;

  final Color? textColor;
  final double radius;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  const CustomBorderedButton({
    super.key,
    required this.text,
    this.width = double.infinity,
    this.height = 55,
    this.backgroundColor = primaryColor,
    required this.onPressed,
    this.textColor,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return   InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color:  bodyTextColor,
            width: 1,
          ),
        ),
        child: Padding(
            padding:  EdgeInsets.all(MySize.size5),
            child:Center(child: Text(text, style: AppTextStyles.label16600BTC,))
        ),

      ),
    );

  }
}

class CustomSocialButton extends StatelessWidget {
  final String text;
  final String image;
  final Color? textColor;
  final double radius;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  const CustomSocialButton({
    super.key,
    required this.text,
    this.backgroundColor,
    required this.onPressed,
    this.textColor,
    required this.image,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55.0,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          backgroundColor: backgroundColor,
          disabledBackgroundColor: Colors.grey[300],
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.40,
              height: 24,
              child: SvgPicture.asset(image),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? const Color(0xffFFFFFF),
                fontWeight: FontWeight.w500,
                fontSize: 12,
                fontFamily: 'Montserrat'
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabButton extends StatelessWidget {
  const CustomTabButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MySize.size120,
        height: MySize.size30,
        decoration: ShapeDecoration(
          color: isSelected ? primaryColor : secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? bgColor : secondaryColor,
            fontSize: MySize.size12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
