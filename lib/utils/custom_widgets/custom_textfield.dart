
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/MySize.dart';
import '../constants/textStyles.dart';

class CustomTextField13 extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final AutovalidateMode? autoValidateMode;
  final int? maxLines;
  final int? minLines;
  final double? radius;
  final FocusNode? focusNode;
  final Color textColor;
  final bool? showCursor;
  final bool readOnly;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final Color fillColor;
  final List<TextInputFormatter> inputFormatter;
  static const Color fillColorDefaultValue = backgroundColor;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const CustomTextField13(
      {super.key,
        this.onTap,
        this.validator,
        this.obscureText = false,
        this.autoValidateMode,
        this.title,
        this.controller,
        this.keyboardType,
        this.maxLines = 1,
        this.minLines,
        this.showCursor,
        this.readOnly = false,
        this.hintText,
        this.fillColor = fillColorDefaultValue,
        this.prefixIcon,
        this.sufixIcon,
        this.textColor = Colors.black54,
        this.onChanged,
        this.focusNode,
        this.inputFormatter = const <TextInputFormatter>[],
        this.radius = 10.0});
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (title == null)
            ? Container()
            : Container(
          margin: const EdgeInsets.only(bottom: 3, left: 2, right: 2),
          child: Text(
            title!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: blackColor,
            ),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          focusNode: focusNode,
          onChanged: onChanged,
          showCursor: showCursor,
          readOnly: readOnly,
          minLines: minLines,
          maxLines: maxLines,
          onTap: onTap,
          autovalidateMode: autoValidateMode,
          obscureText: obscureText,
          validator: validator,
          inputFormatters: inputFormatter,
          cursorColor: primaryColor,
          style: TextStyle(
            // color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: MySize.size14,
          ),
          decoration: InputDecoration(
            fillColor: fillColor,
            filled: true,
            prefixIcon: prefixIcon,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.all(
                Radius.circular(radius!),

              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldBorderColor), // Set border color here
              borderRadius: BorderRadius.all(
                Radius.circular(radius!),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldBorderColor), // Set border color here
              borderRadius: BorderRadius.all(
                Radius.circular(radius!),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: redColor), // Set border color here
              borderRadius: BorderRadius.all(
                Radius.circular(radius!),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: redColor), // Set border color here
              borderRadius: BorderRadius.all(
                Radius.circular(radius!),
              ),
            ),
            hintText: hintText,
            hintStyle: AppTextStyles.label14400BTC,
            isDense: true,
            // fillColor: fillColor,
            // filled: true,
            suffixIcon: sufixIcon,
            contentPadding: const EdgeInsets.fromLTRB(13, 17, 13, 17),
          ),
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}




//
// class CountryFlagNumberTextField extends StatelessWidget {
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final String? initialvalue;
//   final FormFieldValidator<String>? validator;
//   final AutovalidateMode? autovalidateMode;
//   final ValueChanged<CountryCode>? onChanged;
//   final bool? showCursor;
//   final bool readOnly;
//   final bool enabled;
//   final String? title;
//   final String? hintText;
//
//   const CountryFlagNumberTextField(
//       {super.key,
//         this.validator,
//         this.autovalidateMode,
//         this.controller,
//         this.initialvalue,
//         this.keyboardType,
//         this.onChanged,
//         this.showCursor,
//         this.readOnly = false,
//         this.enabled = true,
//         this.title, this.hintText});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         (title == null)
//             ? Container()
//             : Container(
//           margin: const EdgeInsets.only(bottom: 3, left: 2, right: 2),
//           child: Text(
//             title!,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: black1,
//             ),
//           ),
//         ),
//         const SizedBox(height: 5),
//         TextFormField(
//           showCursor: showCursor,
//           readOnly: readOnly,
//           autovalidateMode: autovalidateMode,
//           validator: validator,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'\d')),
//           ],
//           style: const TextStyle(
//               color: Color(0xff272727),
//               fontSize: 14,
//               fontWeight: FontWeight.w400),
//           decoration: InputDecoration(
//             // fillColor: fillColor,
//             hintText: hintText??"",
//             hintStyle: const TextStyle(fontSize: 12,),
//             prefixIcon: Container(
//               margin: const EdgeInsets.fromLTRB(1, 1, 10, 1),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//               ),
//               child: Container(
//                 width: 110,
//                 decoration: BoxDecoration(
//                   color: fillColor,
//                   border: Border.all(
//                     color: primaryColor,
//                     width: 0.25,
//                   ),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: CountryCodePicker(
//                   enabled: enabled,
//                   onChanged: onChanged,
//                   flagWidth: 25,
//                   initialSelection: initialvalue,
//                   showFlagDialog: true,
//                   // showDropDownButton: true,
//                   showCountryOnly: false,
//                   showOnlyCountryWhenClosed: false,
//                   alignLeft: false,
//                   padding: const EdgeInsets.all(0),
//                 ),
//               ),
//             ),
//             // filled: true,
//             contentPadding: const EdgeInsets.fromLTRB(6.5, 12, 6.5, 12),
//             // border: const OutlineInputBorder(
//             //   // borderSide: BorderSide(
//             //   //   width: 1,
//             //   //     color: Colors.pink
//             //   //   // style: BorderStyle.none,
//             //   // ),
//             //   borderRadius: BorderRadius.all(
//             //     Radius.circular(5.0),
//             //   ),
//             // ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: primaryColor),
//               borderRadius: BorderRadius.all(
//                 Radius.circular(5),
//
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: grey6), // Set border color here
//               borderRadius: BorderRadius.all(
//                 Radius.circular(5),
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: red), // Set border color here
//               borderRadius: BorderRadius.all(
//                 Radius.circular(5),
//               ),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: red), // Set border color here
//               borderRadius: BorderRadius.all(
//                 Radius.circular(5),
//               ),
//             ),
//           ),
//           controller: controller,
//           keyboardType: keyboardType,
//         ),
//       ],
//     );
//   }
// }
//
// class CountryFlagTextField extends StatelessWidget {
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final String? initialValue;
//   final FormFieldValidator<String>? validator;
//   final AutovalidateMode? autoValidateMode;
//   final ValueChanged<CountryCode>? onChanged;
//   final bool asterisk;
//   final String? title;
//
//   const CountryFlagTextField(
//       {super.key, this.validator,
//         this.autoValidateMode,
//         this.controller,
//         this.initialValue,
//         this.keyboardType,
//         this.onChanged,
//         this.title,
//         this.asterisk = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         (title == null)
//             ? Container()
//             : RichText(
//           text: TextSpan(
//             text: title,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xff101817),
//             ),
//             children: [
//               (asterisk)
//                   ? const TextSpan(
//                 text: ' *',
//                 style: TextStyle(color: Colors.red, fontSize: 16.0),
//               )
//                   : const TextSpan(text: '')
//             ],
//           ),
//         ),
//         const SizedBox(height: 5),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.0),
//             color: const Color(0xffFFFFFF),
//           ),
//           child: CountryCodePicker(
//             onChanged: onChanged,
//             initialSelection: initialValue,
//             textStyle: const TextStyle(
//               color: Color(0xff828A89),
//               fontWeight: FontWeight.w400,
//               fontSize: 14,
//             ),
//             showCountryOnly: true,
//             showOnlyCountryWhenClosed: true,
//             alignLeft: true,
//             flagWidth: 32,
//             showDropDownButton: true,
//           ),
//         ),
//       ],
//     );
//   }
// }
