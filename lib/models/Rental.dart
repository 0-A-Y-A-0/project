import 'package:project/models/Apartment.dart';

class Rental {
  final int id;
  final int userId;
   DateTime start;
   DateTime end;
  final Apartment apartment;
  final String status; // "pending" "accepted" "ongoing" "passed" "rejected" "canceled"

  Rental({
    required this.id,
    required this.userId,
    required this.start,
    required this.end,
    required this.apartment,
    required this.status,
  });

}