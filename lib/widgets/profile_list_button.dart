import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  const ListButton({super.key, required this.iconPath, required this.text, required this.onPressed});
  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;

    final isRtl = Directionality.of(context) == TextDirection.rtl; //to change icon

    final forwardIconPath = isRtl
        ? "assets/icons/rtl_forward_icon.png"
        : "assets/icons/forward_icon.png";

    return Row(
      children: [
        ImageIcon(
          AssetImage(iconPath),
          color: cs.primary.withAlpha(200),
          size: screenWidth * 0.07,
        ),

        SizedBox(width: screenWidth * 0.03),

        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
              text,
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w500,
                fontSize: 17,
                fontFamily: 'BellotaText',
              )
          ),
        ),

        Spacer(flex: 10),

        IconButton(
          onPressed: onPressed,
          icon: ImageIcon(
            AssetImage(forwardIconPath),
            size: screenWidth * 0.05,
            color: cs.primary.withAlpha(200),
          ),
        )
      ],
    );
  }
}
