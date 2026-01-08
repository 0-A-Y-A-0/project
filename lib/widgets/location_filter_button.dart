import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../generated/l10n/app_localizations.dart';
import '../providers/cities_provider.dart';

class LocationFilterButton extends ConsumerStatefulWidget {
  LocationFilterButton({
    super.key,
    this.selectedGov,
    this.selectedCity,
    this.onSheetClosed,
  });

  int? selectedGov;
  String? selectedCity;
  final VoidCallback? onSheetClosed; // the function that will be done after the sheet is closed (linking)

  @override
  ConsumerState<LocationFilterButton> createState() =>
      _LocationFilterButtonState();
}

class _LocationFilterButtonState extends ConsumerState<LocationFilterButton> {
  // govs list like the backend
  final List<String> governorates = [
    "Damascus",
    "Rif Damascus",
    "Aleppo",
    "Homs",
    "Hama",
    "Latakia",
    "Tartous",
    "Idlib",
    "Daraa",
    "As Suwayda",
    "Quneitra",
    "Deir Ezzor",
    "Al Hasakah",
    "Raqqa",
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AppLocalizations t = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsetsDirectional.only(start: screenWidth * 0.02), //instead of EdgeInsets.only(left: 10),

      child: OutlinedButton(
        // the style .. nothing to talk about here
        style: OutlinedButton.styleFrom(
          backgroundColor: cs.onPrimary.withAlpha(180),
          side: BorderSide(
            color: widget.selectedGov != null
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
              t.location,
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
        final screenWidth = MediaQuery.of(context).size.width;
        final AppLocalizations t = AppLocalizations.of(context)!;

        return StatefulBuilder( // to make the widget stateful
          builder: (context, setModalState) { // setState is the state of the sheet
            return Consumer(// to make the stateful widget stateful
              builder: (context, ref, _) {

                final cities = ref.watch(CitiesProvider(widget.selectedGov));
                return Container(
                  // i forced the height so it doesn't appear too big
                  height: screenHeight * 0.26,
                  padding: EdgeInsetsDirectional.only(start: 10, end: 10, top: 15),
                  //EdgeInsetsDirectional.fromSTEB(screenWidth * 0.02, screenHeight * 0.015, screenWidth * 0.02, 0),
                  child: Column(
                    children: [

                      // Gov dropdown
                      DropdownButtonFormField(
                        initialValue: widget.selectedGov,

                        // hint: Text("Select governorate"),
                        decoration: InputDecoration(
                          labelText: t.governorate,
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

                        // here we should add ... if isLoading => (){} (do nothing
                        onChanged: (value) {
                          if (value == null) return;

                          print("changed ----- $value");

                          // updating the sheet state
                          setModalState(() {
                            widget.selectedGov = value;
                            widget.selectedCity = null;
                          });

                          // updating the button state
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 20),

                      // Cities dropdown
                      DropdownButtonFormField<String?>(
                        initialValue: widget.selectedCity,

                        hint: widget.selectedGov == null
                            ? Text(
                                t.selectGovernorateFirst,
                                style: TextStyle(
                                  color: cs.primary.withAlpha(100),
                                ),
                              )
                            : cities.isLoading
                            ? Text(t.loading)
                            : null,
                        decoration: InputDecoration(
                          labelText: t.city,
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
                            (widget.selectedGov == null || cities.isLoading)
                            ? null
                            : (val) {
                                setState(() {
                                  widget.selectedCity = val;
                                });
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
