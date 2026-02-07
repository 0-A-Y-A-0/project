class UserRating {
  final bool canRate;
  final double? rate;
  final String? comment;
  final int? ratingId;

  UserRating( {required this.canRate, required this.rate, required this.comment, this.ratingId});

}