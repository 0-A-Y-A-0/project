import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        rate: rating['rating'] as double?,
        comment:  rating['comment'] as String?,
      );
    }

    // cannot rate
    else if (data['can_rate'] == false) {
      userRating = UserRating(canRate: false, rate: null, comment: null);
    }

    // can rate
    else {
      userRating = UserRating(canRate: true, rate: null, comment: null);
    }

    print ("${userRating.canRate}");

    state = AsyncData(userRating);

    return userRating;
  }

  /// Optional: submit rating later
  Future<void> submitRating({
    required int apartmentId,
    required double rating,
    String? comment,
  }) async {
    final dio = ref.read(dioProvider);

    await dio.post(
      '/apartments/$apartmentId/rate',
      data: {
        'rating': rating,
        'comment': comment,
      },
    );

    // Update local state after successful submit
    state = AsyncData(
      UserRating(canRate: false, rate: rating.toDouble(), comment: comment),
    );
  }
}

final RatingProvider =
AsyncNotifierProvider<UserRatingNotifier, UserRating>(
  UserRatingNotifier.new,
);



