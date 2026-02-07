import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/apartmentDetailsProvider.dart';

import '../models/UserRating.dart';
import 'dio_provider.dart';

class UserRatingNotifier extends AsyncNotifier<UserRating> {
  @override
  Future<UserRating> build() async {
    return UserRating(canRate: true, rate: null, comment: null);
  }

  Future<UserRating> getStatus({required int apartmentId}) async {
    state = const AsyncLoading();

    final dio = ref.read(dioProvider);

    print ("to the bcak");

    final response = await dio.get('/apartments/$apartmentId/can-rate');
    final data = response.data;

    if (response.statusCode != 200){
      throw Exception('ERROR!!!!!!!!!!!!!!!!!!');
    }

    UserRating userRating;

    print ("DATA CAN RATE ${data['can_rate']}");
    print ("DATA RATING ${data['rating']}");

    // user already rated
    if (data['can_rate'] == false && data['rating'] != null) {
      final rating = data['rating'];

      userRating = UserRating(
        canRate: false,
        rate: double.tryParse(rating['rating']?.toString() ?? '0'),
        comment:  rating['comment'] as String?,
        ratingId: rating['id'],
      );
    }

    // cannot rate
    else if (data['can_rate'] == false) {
      userRating = UserRating(canRate: false, rate: null, comment: null, ratingId: null);
    }

    // can rate
    else {
      userRating = UserRating(canRate: true, rate: null, comment: null, ratingId: null);
    }

    print ("${userRating.canRate}");

    state = AsyncData(userRating);

    return userRating;
  }

  Future<void> submitRating({
    required int apartmentId,
    required double rating,
    String? comment,
  }) async {
    final dio = ref.read(dioProvider);

    final response = await dio.post(
      '/apartments/$apartmentId/rate',
      data: {
        'rating': rating,
        'comment': comment,
      },
    );

    final data = response.data;
    final ratingRes = data['rating'];

    print (ratingRes);


    // Update local state after successful submit
    state = AsyncData(
      UserRating(canRate: false,
          rate: double.tryParse(ratingRes['rating']?.toString() ?? '0'),
          comment: ratingRes['comment'] as String?,
          ratingId: ratingRes['id'],
      ),
    );
  }

  Future<void> editRating({
    required int ratingId,
    required double rating,
    String? comment,
  }) async {
    final dio = ref.read(dioProvider);

    await dio.put(
      '/apartments/${ratingId}/rate/update',
      data: {
        'rating': rating,
        'comment': comment,
      },
    );

    // update local state
    state = AsyncData(
      UserRating(
        canRate: false,
        rate: rating,
        comment: comment!.isEmpty ? null : comment,
        ratingId: ratingId,
      ),
    );
  }

}

final RatingProvider =
AsyncNotifierProvider<UserRatingNotifier, UserRating>(
  UserRatingNotifier.new,
);



