import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/models/Apartment.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/widgets/addRating.dart';

import '../models/url_config.dart';

class RatingTab extends ConsumerWidget {
  const RatingTab({super.key, required this.apartment});

  final Apartment apartment;
  final bool widgetTest = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final t = AppLocalizations.of(context)!;

    final user = ref.watch(UserProvider) ;

    return ListView(
      padding: EdgeInsets.only(top : screenWidth * 0.032, left: screenWidth * 0.015, right: screenWidth * 0.015),
      children: [
        // display the rating
        Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.only(start: screenWidth * 0.035, bottom: screenWidth * 0.04),
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
                  Text(
                    "${apartment.rate}",
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: screenWidth * 0.15,
                      fontFamily: 'BellotaText',
                    ),
                  ),
              
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 5),
                    child: Text(t.basedOn+ " ${apartment.comments?.length} "+ t.review,
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
                  rating: apartment.rate,
                  padding: 3,
                color: cs.primary,
              )
            ],
          ),
        ),

        SizedBox(
          height: screenHeight * 0.02,
        ),

        // your rate
        AddRating(apartmentId: apartment.id,),

        SizedBox(
          height: screenHeight * 0.02,
        ),

        // the comments
        Container(
          width: double.infinity,
          padding: EdgeInsets.all( screenWidth * 0.035),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.transparent),
          ),
          child: (apartment.comments == null || apartment.comments!.isEmpty)
              ? Text("No reviews yet")
          : Column(
            children: List.generate( apartment.comments!.length , (index) {
              final review = apartment.comments![index];

              if (review.photo_url == user!.photo_url) {
                return SizedBox.shrink();
              }

              return ReviewRow(
                picUrl: review.photo_url ?? '',
                name: review.name ?? 'Anonymous',
                rate: review.rate ?? 0,
                comment: review.review,
                divider: index < apartment.comments!.length - 1 ? true : false, // dont put a divider to the last element
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
  const ReviewRow({super.key, required this.divider, required this.picUrl, required this.name, required this.rate, required this.comment, });

  final String picUrl;
  final String name;
  final double rate;
  final String? comment;
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
                child: SizedBox(
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                  child: ClipOval(
                    child: Image.network(
                      "${UrlConfig.storageBaseUrl}/${picUrl}",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Image.asset(
                          'assets/images/apartments/test.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // user name
                  Text(
                    //user name
                    name,
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.045,
                      fontFamily: 'BellotaText',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.005,),

                  SmallStars(
                      rating: rate,
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
            child: Text(
              comment == null ? "No comment" : comment!,
              style: TextStyle(
                color: comment == null ? cs.primary.withAlpha(150) :cs.primary,
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

