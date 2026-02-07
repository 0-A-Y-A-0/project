import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/providers/apartmentDetailsProvider.dart';
import 'package:project/providers/rating_provider.dart';

import '../models/UserRating.dart';
import '../providers/rating_provider.dart';

class AddRating extends ConsumerStatefulWidget {
  const AddRating({super.key, required this.apartmentId});

  final int apartmentId;

  @override
  ConsumerState<AddRating> createState() => _AddRatingState();
}

class _AddRatingState extends ConsumerState<AddRating> {
  // double _rating = 0; // current rating
  // bool _hasRated = false; // tracks if user already rated

  double tempRate = 0;

  final _reviewCtrl = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(RatingProvider.notifier)
          .getStatus(apartmentId: widget.apartmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AppLocalizations t = AppLocalizations.of(context)!;

    final userRate = ref.watch(RatingProvider);

    return userRate.when(
      error: (_, __) =>
          Center(child: Text(t.theresAnError)),
      loading: () => Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth * 0.035),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.transparent),
          ),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      data: (ur) {
        print(ur.canRate);
        print(ur.rate);
        print(ur.comment);

        // user already rated
        if (!ur.canRate && ur.rate != null) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              color: cs.onPrimary.withAlpha(ur.canRate ? 250 : 180),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.onPrimary, width: 4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.yourReview,
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.045,
                    fontFamily: 'BellotaText',
                  ),
                ),

                SizedBox(height: 10),

                RatingBar(
                  initialRating: ur.rate?.toDouble() ?? 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  glowColor: cs.primary.withAlpha(100),
                  ignoreGestures: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  unratedColor: Colors.grey[300],
                  ratingWidget: RatingWidget(
                    full: ImageIcon(
                      AssetImage('assets/icons/filled_star_icon.png'),
                      color: cs.primary,
                    ),
                    half: ImageIcon(
                      AssetImage('assets/icons/half_star_icon.png'),
                      color: cs.primary,
                    ),
                    empty: ImageIcon(
                      AssetImage('assets/icons/star_icon.png'),
                      color: cs.primary,
                    ),
                  ),
                  onRatingUpdate: (double value) {},
                ),

                SizedBox(height: 10),

                _buildSubmittedReview(cs, t, screenWidth),
              ],
            ),
          );
        }

        // can't rate at all
        if (!ur.canRate) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.035),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              t.cantRate,
            ),
          );
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth * 0.03),
          decoration: BoxDecoration(
            color: cs.onPrimary.withAlpha(ur.canRate ? 250 : 180),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.onPrimary, width: 4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.rateThisApartment,
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.045,
                  fontFamily: 'BellotaText',
                ),
              ),

              SizedBox(height: 10),

              RatingBar(
                initialRating: ur.rate?.toDouble() ?? 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                glowColor: cs.primary.withAlpha(100),
                ignoreGestures: false,
                itemPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                unratedColor: Colors.grey[300],
                ratingWidget: RatingWidget(
                  full: ImageIcon(
                    AssetImage('assets/icons/filled_star_icon.png'),
                    color: cs.primary,
                  ),
                  half: ImageIcon(
                    AssetImage('assets/icons/half_star_icon.png'),
                    color: cs.primary,
                  ),
                  empty: ImageIcon(
                    AssetImage('assets/icons/star_icon.png'),
                    color: cs.primary,
                  ),
                ),
                onRatingUpdate: (double value) {
                  setState(() {
                    tempRate = value;
                  });
                },
              ),

              SizedBox(height: 10),

              _buildReviewForm(cs, screenWidth, t),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewForm(
    ColorScheme cs,
    double screenWidth,
    AppLocalizations t,
  ) {
    final userRate = ref.watch(RatingProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // TextFormField(
          //   controller: _reviewCtrl,
          //   decoration: InputDecoration(
          //     labelText: t.rating_addReviewOptional,
          //     labelStyle: TextStyle(
          //       color: cs.primary,
          //       fontWeight: FontWeight.w600,
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //       borderSide: BorderSide(
          //         color: cs.primary.withAlpha(100),
          //         width: 2,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //       borderSide: BorderSide(color: cs.primary, width: 2),
          //     ),
          //   ),
          //   minLines: 1,
          //   maxLines: 8,
          // ),

          GestureDetector(
            onTap: () async {
              // open dialog to write review
              final result = await showDialog<String>(
                context: context,
                builder: (ctx) {
                  final dialogCtrl = TextEditingController(text: _reviewCtrl.text);
                  return AlertDialog(
                    title: Text(t.rating_addReviewOptional),
                    content: TextField(
                      controller: dialogCtrl,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: t.rating_addReviewOptional,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(t.cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, dialogCtrl.text),
                        child: Text(t.common_ok),
                      ),
                    ],
                  );
                },
              );

              if (result != null) {
                setState(() {
                  _reviewCtrl.text = result;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: cs.primary.withAlpha(100)),
                borderRadius: BorderRadius.circular(12),
                color: cs.onPrimary,
              ),
              child: Text(
                _reviewCtrl.text.isEmpty
                    ? t.rating_addReviewOptional
                    : _reviewCtrl.text,
                style: TextStyle(
                  color: _reviewCtrl.text.isEmpty ? cs.primary.withAlpha(150) : cs.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: tempRate == 0 || userRate.isLoading
                  ? null
                  : () async {
                      print('RATING: $tempRate');
                      print('REVIEW: ${_reviewCtrl.text}');

                      await (userRate.value?.ratingId == null
                          ? ref
                                .read(RatingProvider.notifier)
                                .submitRating(
                                  apartmentId: widget.apartmentId,
                                  rating: tempRate,
                                  comment: _reviewCtrl.text,
                                )
                          : ref
                                .read(RatingProvider.notifier)
                                .editRating(
                                  ratingId: userRate.value!.ratingId!,
                                  rating: tempRate,
                                  comment: _reviewCtrl.text,
                                ));
                    },
              style: OutlinedButton.styleFrom(
                backgroundColor: cs.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                userRate.isLoading ? t.loading : t.rating_postReview,
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

  Widget _buildSubmittedReview(
    ColorScheme cs,
    AppLocalizations t,
    double screenWidth,
  ) {
    final userRate = ref.watch(RatingProvider);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userRate.value!.comment == null
                ? t.rating_noWrittenReview
                : userRate.value!.comment!,
            style: TextStyle(color: cs.primary, fontSize: 17),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () async {
                      setState(() {
                        tempRate = userRate.value!.rate ?? 0;
                        _reviewCtrl.text = userRate.value!.comment ?? '';
                      });

                      ref.read(RatingProvider.notifier).state = AsyncData(
                        UserRating(
                          canRate: true,
                          rate: userRate.value!.rate,
                          comment: userRate.value!.comment,
                          ratingId: userRate.value!.ratingId,
                        ),
                      );
                    },
              style: OutlinedButton.styleFrom(
                backgroundColor: cs.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                t.edit,
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
}
