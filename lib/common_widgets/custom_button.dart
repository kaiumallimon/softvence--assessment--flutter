import 'package:assessment/helpers/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.width,
    this.height,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.trailing,
  });

  final double? width;
  final double? height;
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper(context);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.primaryColor,
          side: borderRadius != null
              ? BorderSide(color: backgroundColor!, width: 2)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: textColor ?? Colors.white,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: responsive.scaleFont(16),
              ),
            ),
            if (trailing != null) ...[trailing!],
          ],
        ),
      ),
    );
  }
}
