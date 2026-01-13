import 'package:flutter/material.dart';
import 'package:project/models/Governorates.dart';

class Apartment {
  final int id;
  final String governorate;
  final String city;
  final String street;
  final double rent_price_per_night;

  final String building_number;
  final int floor;
  final int apartment_number;
  final int number_of_bedrooms;
  final int number_of_bathrooms;
  final int area_sq_meters;
  final String description_en;
  final List<String> photos;
  final List<DateTimeRange> rentals;
  final String owner_name;
  final String owner_photo_url;

  final double rate;
  final List<Comment>? comments;

  Apartment({
    required this.id,
    required this.governorate,
    required this.city,
    required this.street,
    required this.rent_price_per_night,
    this.building_number = '',
    this.floor = 0,
    this.apartment_number = 0,
    this.number_of_bedrooms = 0,
    this.number_of_bathrooms = 0,
    this.area_sq_meters = 0,
    this.description_en = '',
    this.photos = const [],
    this.rentals = const [],
    this.owner_name = '',
    this.owner_photo_url = '',
    this.rate = 0,
    this.comments = null
  });
  String makeAddress() => '$governorate, $city, $street';
}

class Comment {
  final String? name;
  final String? photo_url;
  final String? review;
  final double? rate;

  Comment(this.name, this.photo_url, this.review, this.rate);

}
