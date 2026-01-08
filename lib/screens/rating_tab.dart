import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/widgets/addRating.dart';

class RatingTab extends StatelessWidget {
  const RatingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        // display the rating
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("4.5",
              style: TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.w900,
                fontSize: screenWidth * 0.15,
                fontFamily: 'BellotaText',
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 15, left: 5),
              child: Text("Based on 20 reviews",
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.04,
                  fontFamily: 'BellotaText',
                ),
              ),
            )
          ]
        ),

        Divider(
          color: cs.primary.withAlpha(100),
          height: 10,
          thickness: 2,
        ),

        AddRating()

        // ListView.builder(
        //   itemCount: 5,
        //   itemBuilder: (context, index){
        //     return
        //   },
        // )


      ],
    );
  }

  Widget createReview(){
    return Row(
      children: [

      ],
    );
  }
}
