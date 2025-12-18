import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:project/models/aprtment.dart';
import 'package:tab_container/tab_container.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  const ApartmentDetailsScreen({super.key, required this.apartment});
  final Apartment apartment;

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController ;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, // number of tabs
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose(); // Chat said that this important
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: cs.onPrimary,
      appBar: AppBar(
        backgroundColor: cs.onPrimary,
        toolbarHeight: screenHeight * 0.06,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  activeColor: Colors.white,
                  color: Colors.white.withAlpha(150),
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
                color: Colors.white.withAlpha(150),
                disableColor: Colors.white.withAlpha(150),
              ),
            ),
          ),

          // the tabs
          Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            width: double.infinity,
            height: screenHeight * 0.4,
            child: TabContainerFocus(
              controller: _tabController,
              // focusDecoration: BoxDecoration(
              //   border: Border.all(color: cs.primary, width: 3),
              //   color: cs.primary,
              // ),
              // focusPadding: const EdgeInsets.all(10),

              child: TabContainer(
                controller: _tabController,

                tabEdge: TabEdge.left, // where the tabs appear
                tabsStart: 0.1, // where they start (0.1 = 10%)
                tabsEnd: 0.9, // where they end
                tabMaxLength: screenHeight * 0.2, // the tabs are vertical => length means the width of the tab

                borderRadius: BorderRadius.circular(16), // for the entire container
                tabBorderRadius: BorderRadius.circular(16), // only for the tabs
                childPadding: const EdgeInsets.all(10), // for the content

                selectedTextStyle: TextStyle(
                  color: cs.primary,
                  fontSize: screenWidth * 0.045,
                ),
                unselectedTextStyle: TextStyle(
                  color: cs.tertiary,
                  fontSize: screenWidth * 0.04,
                ),

                // the colors of the tabs in order
                colors: [
                  cs.primary,
                  cs.primary,
                  cs.primary,
                ],

                // the titles
                tabs: [
                  ImageIcon(
                    AssetImage("assets/icons/info_icon.png"),
                    color: cs.onPrimary,
                  ),
                  ImageIcon(
                    AssetImage("assets/icons/star_icon.png"),
                    color: cs.onPrimary,
                  ),
                  ImageIcon(
                    AssetImage("assets/icons/more_icon.png"),
                    color: cs.onPrimary,
                  ),
                ],

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Location :   ${widget.apartment.location}",
                      style: TextStyle(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: screenWidth * 0.045),),
                      Text("Price :   ${widget.apartment.price}",
                      style: TextStyle(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: screenWidth * 0.045),)
                    ],
                  ),
                  Container(
                    child: Text('rating'),
                  ),
                  Container(
                    child: Text('map and other stuff'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}