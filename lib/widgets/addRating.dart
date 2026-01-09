import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddRating extends StatefulWidget {
  const AddRating({super.key});

  @override
  State<AddRating> createState() => _AddRatingState();
}

class _AddRatingState extends State<AddRating> {
  double _rating = 0; // current rating
  bool _hasRated = false; // tracks if user already rated

  final _reviewCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: cs.onPrimary.withAlpha(_hasRated ? 250 : 180),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.onPrimary, width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _hasRated ? "Your review:" : "Rate this apartment:",
            style: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.045,
              fontFamily: 'BellotaText',
            ),
          ),

          SizedBox(height: 10,),

          RatingBar(
            initialRating: _rating,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 40,
            glowColor: cs.primary.withAlpha(100),
            ignoreGestures: _hasRated,
            itemPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            unratedColor: Colors.grey[300],
            ratingWidget: RatingWidget(
              full: ImageIcon(AssetImage('assets/icons/filled_star_icon.png'), color: cs.primary,),
              half: ImageIcon(AssetImage('assets/icons/half_star_icon.png'), color: cs.primary),
              empty: ImageIcon(AssetImage('assets/icons/star_icon.png'), color: cs.primary), ),
            onRatingUpdate: (double value) {
              setState(() {
                _rating = value;
              });
            },
          ),

          SizedBox(height: 10,),

          _hasRated
              ? _buildSubmittedReview(cs)
              : _buildReviewForm(cs, screenWidth),
        ],
      ),
    );
  }

  Widget _buildReviewForm(ColorScheme cs, double screenWidth) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          TextFormField(
            controller: _reviewCtrl,
            decoration: InputDecoration(
              labelText: 'Add a review (optional)',
              labelStyle: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w600,
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: cs.primary.withAlpha(100),
                    width: 2,
                  )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: cs.primary,
                  width: 2,
                )
              ),
            ),
            minLines: 1,
            maxLines: 8,
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                if (_rating == 0) return;

                print('RATING: $_rating');
                print('REVIEW: ${_reviewCtrl.text}');

                setState(() {
                  _hasRated = true;
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: cs.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Post your review',
                style: TextStyle(
                  color: cs.onPrimary,
                  fontSize: screenWidth * 0.05,
                  fontFamily: 'Monoglyceride',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmittedReview(ColorScheme cs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      // color: cs.onPrimary,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: cs.onPrimary,
        // ),
      ),
      child: Text(
        _reviewCtrl.text.isEmpty
            ? 'No written review'
            : _reviewCtrl.text,
        style: TextStyle(
          color: cs.primary,
          fontSize: 17,
        ),
      ),
    );
  }


}
