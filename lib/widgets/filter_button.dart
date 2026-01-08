import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  FilterButton({
    super.key,
    required this.label,
    required this.options,
    required this.onSelected,
    required this.value
  });

  final String label; // the filter name
  final List<String> options;
  final void Function() onSelected; // to link with providers

  String? value; // we pass the value from the parent so we can use it freely

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsetsDirectional.only(start: screenWidth * 0.02),

      child: OutlinedButton(
        // the style .. nothing to talk about here
        style: OutlinedButton.styleFrom(
          backgroundColor: cs.onPrimary.withAlpha(180),
          side: BorderSide(
            color: widget.value != null
                ? cs.primary.withAlpha(200) // is selected => visible border
                : Colors.transparent,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),

        // here we gonna show the bottom sheet and options
        onPressed: showOptions,

        // this button works like this ... it takes the components as children
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage("assets/icons/down_icon.png"),
              size: screenWidth * 0.07,
              color: cs.primary.withAlpha(200),
            ),

            SizedBox(width: screenWidth * 0.02),

            Text(
              widget.label,
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.045,
                fontFamily: 'BellotaText',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showOptions() {
    showModalBottomSheet(

      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),

      // here the widget inside the bottom sheet
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Container(
          // i forced the height so it doesn't appear too big
          height: screenHeight * 0.1 * widget.options.length, // 0.1 is the size of the tile (after testing oc :) )
          padding: EdgeInsetsDirectional.fromSTEB(screenWidth * 0.02, screenHeight * 0.015, screenWidth * 0.02, 0),//instead of EdgeInsets.only(right: 10, left: 10, top: 10),

          child: ListView.separated(
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: cs.brightness == Brightness.dark
                  ? Colors.grey.withAlpha(50)
                  : Colors.grey.withAlpha(150),
            ),

            itemCount: widget.options.length,

            itemBuilder: (context, index) {
              final option = widget.options[index];

              return ListTile(
                title: Text(
                    option,
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'BellotaText',
                  ),
                ),

                // change bg color when selected
                tileColor: option == widget.value
                    ? cs.primary.withAlpha(40)
                    : null,

                //
                onTap: () {
                  setState(() {
                    widget.value = option; // it makes it not null => button active
                  });

                  // here we do the function we sent (the linking part)
                  // we send the option to the function to use it
                  widget.onSelected();

                  // to close the sheet after we chose anything
                  Navigator.pop(context);
                },
              );
            },

          ),
        );
      },
    );
  }
}
