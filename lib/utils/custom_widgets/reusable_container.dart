import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:benchmark_estimate/utils/constants/textStyles.dart';
import 'package:flutter/material.dart';

class ProjectReusableContainer extends StatelessWidget {
  // final double width;
  final double height;
  final String projectName;
  final String statusText;

  final String expiryDate;

  final Color textColor;
  final Color bgColor;

  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final VoidCallback ontap;

  const ProjectReusableContainer({
    super.key,
    // required this.width,
    required this.height,
    required this.statusText,
    required this.projectName,
    required this.expiryDate,
    required this.bgColor,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFDEE3EA),
    this.borderRadius = 10.0,
    this.borderWidth = 1.0,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return InkWell(
      onTap: ontap,
      child: Container(
        // width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color:  Color(0xFFDEE3EA),
            width: borderWidth,
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.all(MySize.size15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(projectName, style: AppTextStyles.label13600PTC),
                  Text('Exp. $expiryDate', style:AppTextStyles.label10500STC,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Container(
                    // width: MySize.size100,
                    // height: 21.0,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(
                        color: borderColor,
                        width: 1.0,
                      ),),
                    child: Padding(
                      padding:  EdgeInsets.all( MySize.size5),
                      child: Center(child: Text(statusText, style:   TextStyle(fontSize: 8, fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600, color: textColor))),
                    ),),
                  Icon(Icons.arrow_forward_ios_rounded, color: bodyTextColor,size: MySize.size20,)
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}


class AccountReusableContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  VoidCallback ontap;
  // final String projectName;
  // final String statusText;
  //
  // final String expiryDate;
  //
  // final Color textColor;
  // final Color bgColor;
  //
  // final Color backgroundColor;
  // final Color borderColor;
  final double borderRadius;
  final double borderWidth;

   AccountReusableContainer({
    super.key,
    // required
     this.width = double.infinity,
    required this.height,
    required this.child,
    required this.ontap,
    // required this.statusText,
    // required this.projectName,
    // required this.expiryDate,
    // required this.bgColor,
    // this.textColor = Colors.black,
    // this.backgroundColor = Colors.white,
    // this.borderColor = const Color(0xFFDEE3EA),
    this.borderRadius = 10.0,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color:  Color(0xFFDEE3EA),
              width: borderWidth,
            ),
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical:MySize.size5, horizontal: MySize.size15),
            child:child
            ),

      ),
    );
  }
}

class CategoryReusableContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  VoidCallback ontap;
  // final String projectName;
  // final String statusText;
  //
  // final String expiryDate;
  //
  // final Color textColor;
  final Color bgColor;
  //
  // final Color backgroundColor;
  // final Color borderColor;
  final double borderRadius;
  final double borderWidth;

  CategoryReusableContainer({
    super.key,
    // required
    this.width = double.infinity,
    required this.height,
    required this.child,
    required this.ontap,
    // required this.statusText,
    // required this.projectName,
    // required this.expiryDate,
    required this.bgColor,
    // this.textColor = Colors.black,
    // this.backgroundColor = Colors.white,
    // this.borderColor = const Color(0xFFDEE3EA),
    this.borderRadius = 10.0,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color:  Color(0xFFDEE3EA),
            width: borderWidth,
          ),
        ),
        child: Padding(
            padding:  EdgeInsets.all(MySize.size15),
            child:child
        ),

      ),
    );
  }
}