import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({super.key, required this.label});
  final String label;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool isSelected = false ;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      // the height of the button
        height: screenHeight * 0.08, // 42
        padding: EdgeInsets.only(left: 8, bottom: 8),
        // the button itself
        child: FilterChip(
                label: Text(
                  widget.label,
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'BellotaText',
                ),
                ),
                avatar: ImageIcon(
                  AssetImage("assets/icons/down_icon.png"),
                  size: 18,
                  color: cs.primary,
                ),

                backgroundColor: cs.primary.withAlpha(15),

                // changing the border id selected
                side: BorderSide(
                  color: isSelected ? cs.primary : cs.onPrimary,
                  width: isSelected ? 1 : 0.5,
                ),

                selected: isSelected,
                onSelected: (value) async {
                  // the widget that appears from the bottom (it takes its child's height)
                  final result = await showModalBottomSheet<RangeValues>(
                    context: context,
                    isScrollControlled: true,

                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),

                    // here we add the child depending on the type
                    builder: (context) {
                      return Container(
                        height: 50,
                      );
                    },
                  );

                  // changing the status
                  if (result != null) {
                    setState(() {
                      isSelected = true;
                    });
                  }
                }
            ),
    );
  }
}
