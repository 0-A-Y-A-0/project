import 'package:project/models/Apartment.dart';

class Rental {
  final int id;
  final int userId;
   DateTime start;
   DateTime end;
  final String status; // "pending" "accepted" "ongoing" "passed" "rejected" "canceled"

  // from the apartment
  final int apartmentId;
  final String owner_name;
  final String cover_image_url;

  Rental({
    required this.id,
    required this.userId,
    required this.start,
    required this.end,
    required this.status,
    required this.apartmentId,
    required this.owner_name,
    required this.cover_image_url,
  });

}