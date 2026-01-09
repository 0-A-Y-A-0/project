import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project/widgets/addRating.dart';

class RatingTab extends StatelessWidget {
  const RatingTab({super.key});

  final bool widgetTest = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ListView(
      padding: EdgeInsets.only(top : screenWidth * 0.032, left: screenWidth * 0.015, right: screenWidth * 0.015),
      children: [
        // display the rating
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: screenWidth * 0.035, bottom: screenWidth * 0.04),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.transparent),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("4.5",
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: screenWidth * 0.15,
                      fontFamily: 'BellotaText',
                    ),
                  ),
              
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 5),
                    child: Text("Based on 20 reviews",
                      style: TextStyle(
                        color: cs.primary.withAlpha(160),
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.04,
                        fontFamily: 'BellotaText',
                      ),
                    ),
                  )
                ]
              ),
              
              SmallStars(
                  rating: 3.5,
                  padding: 3,
                color: cs.primary,
              )
            ],
          ),
        ),

        SizedBox(
          height: screenHeight * 0.02,
        ),

        widgetTest ? AddRating()
        : Container(
          width: double.infinity,
          padding: EdgeInsets.all( screenWidth * 0.035),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.transparent),
          ),
          child: Text(
            "You can't rate an apartment that you haven't rented before"
          ),
        ),

        SizedBox(
          height: screenHeight * 0.02,
        ),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all( screenWidth * 0.035),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.transparent),
          ),
          child: Column(
            children: List.generate( 5, (index) {
              return ReviewRow(
                divider: index < 4 ? true : false, // dont put a divider to the last element
              );
            },),
          ),
        ),

        SizedBox(
          height: screenHeight * 0.02,
        ),

      ],
    );
  }
}

class SmallStars extends StatelessWidget {
  SmallStars({ super.key ,required double this.rating, required double this.padding, required this.color});
  final double rating;
  final double padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;

    return RatingBar(
      initialRating: rating,
      allowHalfRating: true,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: 20,
      glow: false,
      ignoreGestures: true,
      itemPadding: EdgeInsets.symmetric(horizontal: padding),
      unratedColor: Colors.grey[300],
      ratingWidget: RatingWidget(
        full: ImageIcon(AssetImage('assets/icons/filled_star_icon.png'), color: color,),
        half: ImageIcon(AssetImage('assets/icons/half_star_icon.png'), color: color),
        empty: ImageIcon(AssetImage('assets/icons/star_icon.png'), color: color), ),
      onRatingUpdate: (double value){},
    );
  }
}


class ReviewRow extends StatelessWidget {
  const ReviewRow({super.key, required this.divider, });

  final bool divider;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      child: Column(
        children: [

          // user pfp + name + rate
          Row(
            children: [
              SizedBox(width: screenWidth * 0.01),
              CircleAvatar(
                radius: screenWidth * 0.08,
                backgroundColor: cs.onPrimary,
                child: CircleAvatar(
                  radius: screenWidth * 0.08,
                  // hereeeeeeeee user.pic
                  backgroundImage: AssetImage('assets/images/apartments/test.jpg'),
                ),

                //Icon(Icons.person, color: cs.primary, size: screenWidth * 0.1),
              ),
              SizedBox(width: screenWidth * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // user name
                  Text(
                    //user name
                    "Mohammad Hassan Jaalouk",
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.045,
                      fontFamily: 'BellotaText',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.005,),

                  SmallStars(
                      rating: 3.5,
                      padding: 5,
                    color: cs.primary.withAlpha(170),
                  )
                ],
              ),

            ],
          ),

          SizedBox(height: 10),

          // the comment 
          SizedBox(
            width: double.infinity,
            //bio although it wont be better than this one
            child: Text(
              "this is Hasan he is very mja3lak dkhfkjf fh fkhf fkhf kh kh kh kh here we are introducing the amazing owner of this amazing apartment",
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.045,
                fontFamily: 'BellotaText',
              ),
            ),
          ),
          
          Divider(
            height: 20,
            thickness: 1,
            indent: 5,
            endIndent: 5,
            color: cs.primary.withAlpha(divider ? 50 : 0),
          )
        ],
      ),
    );
  }
}

