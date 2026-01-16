import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/models/Apartment.dart';
import 'package:project/widgets/apartment_widget.dart';
import 'package:project/widgets/filter_button.dart';
import 'package:project/widgets/location_filter_button.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

import '../models/Governorates.dart';
import '../providers/apartmentsProvider.dart';

class SearchScreen extends ConsumerStatefulWidget {

  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {

  // the filters values
  int? selectedGovNum;
  String? selectedCity;
  int? selectedCityIndex;
  int? priceValue;
  int? minPrice;
  int? maxPrice;
  int? rateValue;
  int? minRate;
  int? maxRate;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final apartments = ref.watch(ApartmentsProvider);
    AppLocalizations t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: cs.onPrimary,

      body: SuperScaffold(
        appBar: SuperAppBar(
          // we make  it transparent to make a cool effect ... i'm a genius i know🦄
          backgroundColor: cs.onPrimary.withAlpha(140),

          // a fixed title
          title: Text(
            t.appName,
            style: TextStyle(
              color: cs.primary,
              fontSize: 30,
              fontWeight: FontWeight.w200,
              fontFamily: 'Monoglyceride',
            ),
          ),

          // the icon next to the title
          actions: Container(
            margin: EdgeInsetsDirectional.only(end: screenWidth * 0.06, top: screenHeight * 0.007),
            child: ImageIcon(
              AssetImage('assets/icons/bell_icon.png'),
              size: 25,
              color: cs.primary,
            ),
          ),

          // the search bar ... 🙂
          searchBar: SuperSearchBar(
            placeholderText: t.search,
            cancelButtonText: t.cancel,
            scrollBehavior: SearchBarScrollBehavior.pinned,
            // here we change the behaviour
            animationBehavior: SearchBarAnimationBehavior.steady,
            //i don't know the difference
            // the cancel button
            cancelTextStyle: TextStyle(
              color: cs.primary.withAlpha(150),
              fontFamily: 'BellotaText', // it doesn't respond to the font
            ),

            // the text we write
            textStyle: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),

            // Search
            placeholderTextStyle: TextStyle(
              color: cs.primary.withAlpha(20),
              fontWeight: FontWeight.w200,
              fontSize: 17,
            ),

            prefixIcon: Icon(Icons.search, color: cs.secondary),
          ),

          // this title has animation and stuff ... but our font couldn't apply to the animation
          // so i disabled it
          largeTitle: SuperLargeTitle(
            enabled: false,
            largeTitle:t.ourApp,
            textStyle: TextStyle(
              color: cs.primary,
              fontSize: 30,
              fontFamily: 'Monoglyceride',
            ),
          ),

          // this is the bottom side of the bar (the filters)
          bottom: SuperAppBarBottom(
            enabled: true,
            height: screenHeight * 0.08,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // spacing: 4,
                children: [

                  createClearButton(screenWidth),//so it uses media query

                  LocationFilterButton(
                    selectedGov: selectedGovNum,
                    selectedCity: selectedCity,
                    selectedCityIndex: selectedCityIndex,
                    onSheetClosed: (selectedGov, selectedCity) {

                      // updating the values
                      setState(() {
                        selectedGovNum = selectedGov;
                        this.selectedCity = selectedCity;
                      });

                      print("$selectedGovNum       $selectedCity");

                      // refreshing
                      ref.read(ApartmentsProvider.notifier).fetchApartments(
                          dataMap: {
                            'governorate' : selectedGovNum,
                            'city' : selectedCity,
                            'min_price' : minPrice,
                            'max_price' : maxPrice,
                          }
                      );
                    },
                  ),

                  FilterButton(
                    value: priceValue,
                    label: t.price,
                    options: [
                      t.priceOptionLessThan1000,
                      t.priceOptionBetween1000And2500,
                      t.priceOptionMoreThan2500,
                    ],
                    onSelected: (index) {

                      // setting the values
                      setState(() {
                        priceValue = index;

                        if (index == 0) {
                          minPrice = 0;
                          maxPrice = 100;
                        } else if (index == 1) {
                          minPrice = 100;
                          maxPrice = 250;
                        } else if (index == 2) {
                          minPrice = 250;
                          maxPrice = null; // == infinity
                        }
                      });

                      print ("$minPrice          $maxPrice");

                      // refreshing
                      ref.read(ApartmentsProvider.notifier).fetchApartments(
                          dataMap: {
                            'governorate' : selectedGovNum,
                            'city' : selectedCity,
                            'min_price' : minPrice,
                            'max_price' : maxPrice,
                          }
                      );
                    },
                  ),

                  FilterButton(
                    value: rateValue,
                    label: t.rating,
                    options: [t.ratingOptionLessThan3, t.ratingOptionBetween2And4],
                      onSelected: (index) {
                      print("changed ----- $index");
                    },
                  ),
                ],
              ),
            ),
          ),

          // the border at the bottom
          border: Border(bottom: BorderSide(color: cs.onPrimary, width: 0)),
        ),

        body: apartments.when(
            loading: () {
              return Container(
                alignment: Alignment.center,
                height: 50,
                child: CircularProgressIndicator(),
              );
            },
            error: (_, __) {
              return Center(child: Text("there's an error, try again later :(")) ;
            },
            data: (list){
              if (list.isEmpty) {
                return Center(
                  child: Text("No apartment matches your search"),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () async {
                  ref.read(ApartmentsProvider.notifier).fetchApartments(
                      dataMap: {
                        'governorate' : selectedGovNum,
                        'city' : selectedCity,
                        'min_price' : minPrice,
                        'max_price' : maxPrice,
                      }
                  );
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ApartmentWidget(
                      apartment: list[index] ,
                      height: 200,
                    );
                  },
                ),
              );
            },
        ),
      ),
    );
  }

  Padding createClearButton(double screenWidth){
    return Padding(
        padding: EdgeInsetsDirectional.only(start: screenWidth * 0.06),

        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onPrimary.withAlpha(180),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withAlpha(170),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            AppLocalizations.of(context)!.clearFilters,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary.withAlpha(130),
              fontWeight: FontWeight.w600,
              fontSize: MediaQuery.of(context).size.width * 0.045,
              fontFamily: 'BellotaText',
            ),
          ),
          onPressed: () {

            // if nothing is changed do nothing
            if (
            selectedGovNum == null &&
            selectedCity == null&&
            selectedCityIndex == null &&
            priceValue == null &&
            minPrice == null &&
            maxPrice == null &&
            rateValue == null &&
            minRate == null &&
            maxRate == null
            ) {
              return ;
            }

            selectedGovNum = null;
            selectedCity = null;
            selectedCityIndex = null;
            priceValue = null;
            minPrice = null;
            maxPrice = null;
            rateValue = null;
            minRate = null;
            maxRate = null;

            ref.read(ApartmentsProvider.notifier).fetchApartments(
                dataMap: {
                  'governorate' : selectedGovNum,
                  'city' : selectedCity,
                  'min_price' : minPrice,
                  'max_price' : maxPrice,
                }
            );

            // to refresh everything
            setState(() {
            });
          },
        )
    );
  }
}
