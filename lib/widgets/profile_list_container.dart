import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// the widget that contains the list buttons inside it
class ListContainer extends StatelessWidget {
  const ListContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
        margin: EdgeInsets.all(screenWidth * 0.025),
        padding: EdgeInsetsDirectional.only(start: screenWidth * 0.025,),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: cs.onPrimary,
              width: 1
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: screenWidth * 0.03, // the shadow size
              offset: Offset(0, 0),
            ),
          ],
        ),

        child: child
    );
  }
}
