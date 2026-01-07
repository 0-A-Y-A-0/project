import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:project/components/theme.dart';
import 'package:project/models/Apartment.dart';
import 'package:project/widgets/apartment_info.dart';
import 'package:project/widgets/booking_fields.dart';
import 'package:project/widgets/calender_show_only.dart';
import 'package:tab_container/tab_container.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  const ApartmentDetailsScreen({super.key, required this.apartment});
  final Apartment apartment;

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen>
    with SingleTickerProviderStateMixin {
  // to add a tab :
  // increase the number of tabs in the controller
  // add an icon (pay attention to the .index)
  // add a color for the tab
  // add a child for the tab

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5, // number of tabs
      vsync: this,
    );

    // here we listen to the changes made by the tab controller
    _tabController.addListener(() {
      setState(() {}); // rebuild when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Chat said that this important
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final taken = <DateTimeRange>[
      DateTimeRange(start: DateTime(2026, 1, 8), end: DateTime(2026, 1, 14)),
      DateTimeRange(start: DateTime(2026, 2, 1), end: DateTime(2026, 2, 3)),
      DateTimeRange(start: DateTime(2025, 2, 1), end: DateTime(2025, 5, 3)),
    ];

    return Scaffold(
      backgroundColor: cs.onPrimary,
      appBar: AppBar(
        backgroundColor: cs.onPrimary,
        toolbarHeight: screenHeight * 0.06,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // the photos
          SizedBox(
            // to control the height
            height: screenHeight * 0.33,
            child: Swiper(
              // similar to the listview builder
              itemCount: 5, // it should be list.length
              itemBuilder: (context, index) {
                return ClipRRect(
                  // borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    // we should pass the pics list here
                    "assets/images/apartments/test.jpg",
                    width: double.infinity,
                    height: screenHeight * 0.33,
                    fit: BoxFit.cover,
                  ),
                );
              },

              // the dots
              pagination: SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                  // i wanted it to be beige anyway
                  activeColor: AppTheme.beige,
                  color: AppTheme.beige.withAlpha(150),
                  size: screenWidth * 0.015, // the normal size
                  activeSize: screenWidth * 0.025, // the active size
                  space: screenWidth * 0.02, // the space between them
                ),
              ),

              // the default layout is STACK
              // if we chose TINDER we have to specify the item height and width
              // layout: SwiperLayout.TINDER,
              // itemHeight: 200,
              // itemWidth: 400,

              //  left/right arrows
              control: SwiperControl(
                color: AppTheme.beige.withAlpha(150),
                disableColor: AppTheme.beige.withAlpha(150),
              ),
            ),
          ),

          // the tabs
          Container(
            margin: EdgeInsets.only(top: 10, left: 8, right: 8),
            width: double.infinity,
            height: screenHeight * 0.5,

            child: TabContainer(
              controller: _tabController,

              tabEdge: TabEdge.top, // where the tabs appear
              tabsStart: 0, // where they start (0.1 = 10%)
              tabsEnd: 1, // where they end
              // tabMaxLength: screenWidth * 0.2, // length means the width of the tab ... the default is the best
              borderRadius: BorderRadius.circular(
                8,
              ), // for the entire container
              tabBorderRadius: BorderRadius.circular(8), // only for the tabs
              childPadding: const EdgeInsets.only(top: 1), // for the content
              // this doesn't do anything
              // selectedTextStyle: TextStyle(
              //   color: Colors.yellow,
              //   fontSize: screenWidth * 0.045,
              // ),
              // unselectedTextStyle: TextStyle(
              //   color: cs.tertiary,
              //   fontSize: screenWidth * 0.04,
              // ),

              // the colors of the tabs in order
              colors: [
                cs.primary.withAlpha(120),
                cs.primary.withAlpha(120),
                cs.primary.withAlpha(120),
                cs.primary.withAlpha(120),
                cs.primary.withAlpha(120),
              ],

              // the titles
              tabs: [
                createTabIcon(
                  path: "assets/icons/info_icon.png",
                  index: _tabController.index,
                  value: 0,
                  cs: cs,
                ),

                createTabIcon(
                  path: "assets/icons/star_icon.png",
                  index: _tabController.index,
                  value: 1,
                  cs: cs,
                ),

                createTabIcon(
                  path: "assets/icons/calendar_icon.png",
                  index: _tabController.index,
                  value: 2,
                  cs: cs,
                ),

                createTabIcon(
                  path: "assets/icons/location_icon.png",
                  index: _tabController.index,
                  value: 3,
                  cs: cs,
                ),

                createTabIcon(
                  path: "assets/icons/bookmark_icon.png",
                  index: _tabController.index,
                  value: 4,
                  cs: cs,
                ),
              ],

              children: [
                ApartmentInfo(apartment: Apartment(governorate: Governorate.Damascus, city: "Mazzeh", street: "street", building_number: "44", floor: 4, apartment_number: 4, number_of_bedrooms: 3, number_of_bathrooms: 2, area_sq_meters: 160, description_en: " beautidul and amazing", rent_price_per_night: 456.3)),
                Text('rating'),
                TakenDaysCalendar(
                  takenRanges: taken,
                  firstDate: DateTime(2025, 1, 1),
                  lastDate: DateTime(2026, 12, 31),
                ),
                Text('map + location'),
                BookingScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

ImageIcon createTabIcon({
  required String path,
  required int index,
  required int value,
  required ColorScheme cs,
}) {
  return ImageIcon(
    AssetImage(path),
    color: index == value ? cs.onPrimary : cs.primary.withAlpha(160),
    size: index == value ? 30 : 20,
  );

  // this was the code for each icon
  // ImageIcon(
  //   AssetImage("assets/icons/calendar_icon.png"),
  //   color: _tabController.index == 2
  //       ? iconsActive
  //       : iconsDisabled,
  //   size: _tabController.index == 2
  //       ? activeSize
  //       : disabledSize,
  // ),
}
