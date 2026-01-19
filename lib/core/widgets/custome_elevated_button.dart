import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool hasBorder;
  final double? width;

  const CustomElevatedButton({
    super.key,
    required this.child,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.hasBorder = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.sizeOf(context).width;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: width == null
            ? Size(_screenWidth, 44.8.h)
            : Size(width!, 44.8.h),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      onPressed: onTap,
      child: child,
    );
  }
}
