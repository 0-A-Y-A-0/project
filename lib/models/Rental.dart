import 'package:project/models/Apartment.dart';

class Rental {
  final int id;
  final int userId;
   DateTime start;
   DateTime end;
  final String status; // "pending" "approved" "rejected" "canceled"

  // pending & no edit => edit normal, cancel normal ------
  // approved & no edit => edit normal
  // approved & edit => cancel edit (it's pending edit)
  // there's no pending & edit

  // from the apartment
  final int apartmentId;
  final String owner_name;
  final String? cover_image_url;

  // the update request
  UpdateRequest? updateRequest;

  Rental({
    required this.id,
    required this.userId,
    required this.start,
    required this.end,
    required this.status,
    required this.apartmentId,
    required this.owner_name,
    required this.cover_image_url,
    this.updateRequest = null
  });

}

class UpdateRequest{
  final int? id;
  final DateTime? start;
  final DateTime? end;

  UpdateRequest({required this.start, required this.end, required this.id});
}