import 'dart:ffi';

import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({super.key, required this.label, this.withIcon = true});

  final String label;
  final bool withIcon; // if we want the icon or not

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String? selectedOption;

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

        // if we want the icon or not ... i don't know ... it might be useful
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
          // the value inside <> its the value we gonna return to the backend
          final result = await showModalBottomSheet<int>(
            context: context,
            isScrollControlled: true,

            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),

            // here we add the child depending on the type
            builder: (context) {
              return Container(
                  // height: 50
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: DropdownButton<String>(
                  isExpanded: true,
                  menuWidth: double.infinity,
                    value: selectedOption,
                    items: ["Option 1", "Option 2", "Option 3"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (value) {
                        selectedOption = value;
                        print("changed");
                    },
                  hint: Text("Select an option"),
                ),

              );
            },
          );

          // changing the status
          if (result != null || selectedOption != null) {
            setState(() {
              isSelected = true;
              print("idk what the hell should happen here");
            });
          }
        },
      ),
    );
  }
}
