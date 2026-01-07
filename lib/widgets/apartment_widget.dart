import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:project/models/Apartment.dart';
import 'package:project/screens/apartment_details_screen.dart';

class ApartmentWidget extends StatefulWidget {
  ApartmentWidget({super.key, required this.apartment, this.height = 200});

  final Apartment apartment ;
  final double height;

  @override
  State<ApartmentWidget> createState() => _ApartmentWidgetState();
}

class _ApartmentWidgetState extends State<ApartmentWidget> {
    bool isFav = false; // just for testing ... it should be removed in the future
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return
      Container(
        margin: EdgeInsets.only(left:screenWidth * 0.03, right: screenWidth * 0.03, bottom: screenWidth * 0.04 ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(cs.brightness == Brightness.light
              ? 100 : 150),
              blurRadius: screenWidth * 0.03,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // the apartment image
                    Image.network(
                      widget.apartment.photos.isEmpty ? "assets/images/apartments/test.jpg" : "http://10.0.2.2:8000/storage/${widget.apartment.photos[0]}",
                      width: double.infinity,
                      height: screenHeight * 0.3,
                      fit: BoxFit.cover,

                        errorBuilder: (_, __, ___) {
                          return Image.asset(
                            'assets/images/apartments/test.jpg',
                            width: double.infinity,
                            height: screenHeight * 0.3,
                            fit: BoxFit.cover,
                          );
                        }
                    ),

                    // the gradiant
                    Positioned(
                      // this tells the widget where to start from ... so
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        alignment: AlignmentGeometry.bottomLeft,
                        width: double.infinity,
                        height: screenHeight * 0.3 / 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [cs.primary, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),

                    // the left border
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.3,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: cs.brightness == Brightness.light
                                ? cs.secondary
                                : Color.alphaBlend(
                              Colors.black.withAlpha(30),
                              cs.secondary,
                            ),
                            width: 3,
                          ),
                        ),
                      ),
                    ),

                    // the text
                    Positioned(
                      // this tells the widget where to start from
                      bottom: 5,
                      left: 15,
                      child: SizedBox(
                        width: screenWidth * 0.55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.apartment.makeAddress(),
                              style: TextStyle(
                                  color: cs.onPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: screenWidth * 0.045,
                                  fontFamily: 'BellotaText',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),

                            Text(
                              "${widget.apartment.rent_price_per_night} \$",
                              style: TextStyle(
                                  color: cs.onPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045,
                                  fontFamily: 'BellotaText',
                              ),
                            )
                          ],
                        ),
                      )
                    ),

                    // inkwell effect (we put it on top of the stack)
                    Positioned.fill(
                      // we needed this so tell the inkwell its size ... or we'll get a big long ugly error bro ... believe me
                      child: Material(
                        // this for the inkwell to make the effect
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: (){
                                print("clicked -----------------------------");
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: ApartmentDetailsScreen(apartmentId: widget.apartment.id),
                                withNavBar: false );// to hide the navigation bar);
                              },
                              // splashColor: cs.secondary.withAlpha(50),
                      )),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 15,
                      child: Row(
                        spacing: 0,
                      children: [
                        IconButton(onPressed: (){},
                            icon: ImageIcon(
                              AssetImage('assets/icons/chat_icon.png'),
                              size: screenWidth * 0.07,
                              color: cs.onPrimary,
                            ),
                        ),

                        IconButton(onPressed: (){
                          // just for testing ...
                          setState(() {
                            isFav = !isFav; // toggle favorite
                          });
                          print(isFav);
                        },
                            icon: ImageIcon(
                              // also for testing
                              AssetImage(isFav
                                  ? 'assets/icons/filled_heart_icon.png'
                                  : 'assets/icons/fav_icon.png'),
                              size: screenWidth * 0.07,
                              color: cs.onPrimary,
                            ),

                          // to remove the splash effect
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        )
                      ],
                    ))

                  ],
                )
            ),
      );
  }
}
