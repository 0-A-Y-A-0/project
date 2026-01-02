import 'package:flutter/material.dart';
import 'package:project/models/Apartment.dart';
import 'package:project/widgets/apartment_widget.dart';
import 'package:project/widgets/filter_button.dart';
import 'package:project/widgets/location_filter_button.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: cs.onPrimary,

      body: SuperScaffold(
          appBar: SuperAppBar(
            // we make  it transparent to make a cool effect ... i'm a genius i know🦄
            backgroundColor: cs.onPrimary.withAlpha(140),

            // a fixed title
            title: Text("My App",
            style: TextStyle(
              color: cs.primary,
              fontSize: 30,
              fontWeight: FontWeight.w200,
              fontFamily: 'Monoglyceride',
            ),),

            // the icon next to the title
            actions: Container(
              margin: EdgeInsets.only(right: 20, top: 10),
              child: ImageIcon(
                AssetImage('assets/icons/filter_icon.png'),
                 size: 24,
                color: cs.primary,
              ),
            ),

            // the search bar ... 🙂
            searchBar: SuperSearchBar(
              scrollBehavior: SearchBarScrollBehavior.pinned, // here we change the behaviour
              animationBehavior: SearchBarAnimationBehavior.steady, //i don't know the difference
              // the cancel button
              cancelTextStyle: TextStyle(
                color: cs.primary.withAlpha(150),
                fontFamily: 'BellotaText', // it doesn't respond to the font
              ),

              // the text we write
              textStyle: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w400,
                  fontSize:17),

              // Search
              placeholderTextStyle: TextStyle(
                  color: cs.primary.withAlpha(20),
                  fontWeight: FontWeight.w200,
                  fontSize:17),

              prefixIcon: Icon(
                  Icons.search,
                color: cs.secondary,
              )
            ),

            // this title has animation and stuff ... but our font couldn't apply to the animation
            // so i disabled it
            largeTitle: SuperLargeTitle(
              enabled: false,
              largeTitle: "Our App",
              textStyle: TextStyle(
                color: cs.primary,
                fontSize: 30,
                fontFamily: 'Monoglyceride',
              ),
            ),

            // this is the bottom side of the bar
            bottom:
            SuperAppBarBottom(
              enabled: true,
              height: screenHeight * 0.08,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // spacing: 4,
                    children: [

                      LocationFilterButton(
                          governorates: ["D", "A", "S", "L"], // if we duplicate items bad things happen
                          cities: ["D", "A", "S", "L2"],
                          onGovernorateSelected: (option){
                            print("changed ----- $option");
                          },
                          onCitySelected: (option){
                            print("changed ----- $option");
                          },
                      ),

                      FilterButton(
                          label: "Price",
                        options: [
                          "Less than 1000\$",
                          "Between 1000\$ and 2500\$",
                          "More than 2500\$ "
                        ],
                        onSelected: (option){
                            print("changed ----- $option");
                        },
                      ),

                      FilterButton(
                        label: "Rating",
                        options: [
                          "Less than ☆☆☆",
                          "Between ☆☆ and ☆☆☆☆",
                        ],
                        onSelected: (option){
                          print("changed ----- $option");
                        },
                      ),


                    ],
                  )
              )
            ),

            // the border at the bottom
            border: Border(
              bottom: BorderSide(
                color: cs.onPrimary,
                width: 0,
              ),
            ),
          ),


        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return ApartmentWidget(apartment: Apartment( governorate: Governorate.Damascus,city: "here",street:"rfe",building_number: "32",floor: 3, apartment_number: 1, number_of_bedrooms: 2, number_of_bathrooms: 1, area_sq_meters: 100, description_en: "Beautiful apartment", rent_price_per_night: 100.0), height: 200);  
          },
        ),
      ),
    );
  }
}