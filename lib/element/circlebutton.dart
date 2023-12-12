import 'package:flutter/material.dart';

class CircleColorButton extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onPressed;

  const CircleColorButton({
    required this.color,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: CircleBorder(),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}