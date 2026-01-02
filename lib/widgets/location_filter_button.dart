import 'dart:ffi';

import 'package:flutter/material.dart';

class LocationFilterButton extends StatefulWidget {
  const LocationFilterButton({
    super.key,
    required this.governorates, required this.onGovernorateSelected, required this.onCitySelected, required this.cities,
  });

  final List<String> governorates;
  final List<String> cities; // i thinkkkkkkkk we chould handle the provider when we call this class

  // to link with providers
  final void Function(String gov) onGovernorateSelected;
  final void Function(String city) onCitySelected;

  // --------------------------
  // we can add loading bools so we can use the for ui

  @override
  State<LocationFilterButton> createState() => _LocationFilterButtonState();
}

class _LocationFilterButtonState extends State<LocationFilterButton> {
  String? _selectedGov;
  String? _selectedCity;

  // _selectedGov != null

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(left: 10),

      child: OutlinedButton(
        // the style .. nothing to talk about here
        style: OutlinedButton.styleFrom(
          backgroundColor: cs.onPrimary.withAlpha(180),
          side: BorderSide(
            color: _selectedGov != null
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
              "Location",
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
        final screenHeight = MediaQuery.of(context).size.height;

        return Container(
          // i forced the height so it doesn't appear too big
          height: screenHeight * 0.26,
          padding: EdgeInsets.only(right: 10, left: 10, top: 15),
          child: Column(
            children: [
              // Gov dropdown
              DropdownButtonFormField(
                initialValue: _selectedGov,

                  // for next time ... isLoading => change the text
                  hint: Text(
                      "Select governorate"
                  ),
                  decoration: InputDecoration(
                    labelText: 'Governorate',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  items: widget.governorates
                      .map(
                        (gov) => DropdownMenuItem(
                      value: gov,
                      child: Text(gov),
                    ),
                  ).toList(),

                  // here we should add ... if isLoading => (){} (do nothing
                  onChanged:(String? value) {
                    if (value == null) return;

                    setState(() {
                      _selectedGov = value;
                      _selectedCity = null; // we always reset the city after choosing a gov
                    });

                    // then we call the function we sent
                    // linking with the provider (go fetch cities/ change filter state)
                    widget.onGovernorateSelected(value);
                  },
              ),

              const SizedBox(height: 20),

              // Cities dropdown
              DropdownButtonFormField(
                initialValue: _selectedCity,

                // for next time ... isLoading => change the text
                hint: _selectedGov == null
                ? const Text("Select governorate first")
              : const Text("Select city"),
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                ),

                items: widget.cities
                    .map(
                      (city) => DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  ),
                ).toList(),

                // here we should add ... if isLoading => (){} (do nothing
                onChanged:(_selectedGov == null)
                    ? null
                    : (String? value) {
                  if (value == null) return;

                  setState(() {
                    _selectedCity = value;
                  });

                  widget.onCitySelected(value);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
