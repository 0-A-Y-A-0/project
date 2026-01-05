import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/Governorates.dart';
import '../providers/cities_provider.dart';

class LocationFilterButton extends ConsumerStatefulWidget {
  LocationFilterButton({
    super.key,
    this.selectedGov,
    this.selectedCity,
    this.selectedCityIndex,
    this.onSheetClosed,
  });

  int? selectedGov;
  String? selectedCity;
  int? selectedCityIndex;
  final VoidCallback? onSheetClosed; // the function that will be done after the sheet is closed (linking)

  @override
  ConsumerState<LocationFilterButton> createState() =>
      _LocationFilterButtonState();
}

class _LocationFilterButtonState extends ConsumerState<LocationFilterButton> {
  final List<String> governorates = Governorates.governorates;

  // we should not use widget. ... so we do this
  int? _selectedGov;
  String? _selectedCity;
  int? _selectedCityIndex;

  @override
  void initState() {
    super.initState();
    _selectedGov = widget.selectedGov;
    _selectedCity = widget.selectedCity;
    _selectedCityIndex = widget.selectedCityIndex;
  }

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
        final cs = Theme.of(context).colorScheme;
        final screenHeight = MediaQuery.of(context).size.height;

        return StatefulBuilder( // to make the widget stateful
          builder: (context, setModalState) { // setState is the state of the sheet
            return Consumer(// to make the stateful widget stateful
              builder: (context, ref, _) {

                final cities = ref.watch(CitiesProvider(_selectedGov));
                return Container(
                  // i forced the height so it doesn't appear too big
                  height: screenHeight * 0.26,
                  padding: EdgeInsets.only(right: 10, left: 10, top: 15),
                  child: Column(
                    children: [

                      // Gov dropdown
                      DropdownButtonFormField(
                        initialValue: _selectedGov,

                        // hint: Text("Select governorate"),
                        decoration: InputDecoration(
                          labelText: 'Governorate',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: List.generate(
                          governorates.length,
                          (i) => DropdownMenuItem(
                            value: i,
                            child: Text(governorates[i]),
                          ),
                        ),

                        // here we should add ... if isLoading => (){} (do nothing)
                        onChanged: (value) {
                          if (value == null) return;

                          print("changed ----- $value");

                          // updating the sheet state
                          setModalState(() {
                            _selectedCity = null;
                            _selectedCityIndex = null;
                            _selectedGov = value;
                          });

                          // updating the button state
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 20),

                      // Cities dropdown
                      DropdownButtonFormField<String?>(
                        // this forces the widget to refresh each time selectedGov changes
                        // without it an error will happen when we select a city then select another gov
                        key: ValueKey(_selectedGov),
                        initialValue: cities.when(
                          data: (list) {
                            if (_selectedCity == null) return null;
                            if (!list.contains(_selectedCity)) return null;
                            return _selectedCity;
                          },
                          loading: () => null,
                          error: (_, __) => null,
                        ),

                        hint: _selectedGov == null
                            ? Text(
                                "Select governorate first",
                                style: TextStyle(
                                  color: cs.primary.withAlpha(100),
                                ),
                              )
                            : cities.isLoading
                            ? Text("Loading...")
                            : null,
                        decoration: InputDecoration(
                          labelText: "City",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        // we can add a loading widget here i think
                        items: cities.when(
                          data: (cities) => cities
                              .map(
                                (city) => DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                ),
                              )
                              .toList(),
                          loading: () => [],
                          error: (_, __) => [],
                        ),

                        // here we should add ... if isLoading => (){} (do nothing
                        onChanged:
                            (_selectedGov == null || cities.isLoading)
                            ? null
                            : (val) {
                              if (val == null) return;

                                setState(() {
                                  _selectedCity = val;
                                  _selectedCityIndex=  cities.value!.indexOf(val);
                                });

                                // to take the city index
                              },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ).then((_) {
      // this is after the sheet closes
      widget.onSheetClosed!();
    });
  }
}
