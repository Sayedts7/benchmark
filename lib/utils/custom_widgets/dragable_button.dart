// import 'package:flutter/material.dart';
//
// class DraggableFloatingButton extends StatefulWidget {
//   final VoidCallback onPressed;
//   final IconData icon;
//   final Color backgroundColor;
//   final Color iconColor;
//
//   const DraggableFloatingButton({
//     Key? key,
//     required this.onPressed,
//     required this.icon,
//     this.backgroundColor = Colors.blue,
//     this.iconColor = Colors.white,
//   }) : super(key: key);
//
//   @override
//   _DraggableFloatingButtonState createState() =>
//       _DraggableFloatingButtonState();
// }
//
// class _DraggableFloatingButtonState extends State<DraggableFloatingButton> {
//   double x = 300.0;
//   double y = 700.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           left: x,
//           top: y,
//           child: Draggable(
//             feedback: _buildButton(),
//             childWhenDragging: Container(),
//             onDragEnd: (dragDetails) {
//               setState(() {
//                 final screenSize = MediaQuery.of(context).size;
//
//                 // Ensure the button stays within the horizontal bounds
//                 x = dragDetails.offset.dx.clamp(0.0, screenSize.width - 56);
//
//                 // Ensure the button stays within the vertical bounds
//                 y = dragDetails.offset.dy.clamp(0.0, screenSize.height - 56);
//               });
//             },
//             child: _buildButton(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildButton() {
//     return FloatingActionButton(
//       onPressed: widget.onPressed,
//       backgroundColor: widget.backgroundColor,
//       child: Icon(
//         widget.icon,
//         color: widget.iconColor,
//       ),
//     );
//   }
// }
