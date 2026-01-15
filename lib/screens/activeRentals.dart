
import 'package:flutter/material.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/models/Apartment.dart';
import 'package:project/models/Rental.dart';
import 'package:project/widgets/rental_widget.dart';

class ActiveRentalsScreen extends StatelessWidget {
  const ActiveRentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    final AppLocalizations t = AppLocalizations.of(context)!;
    
    return Scaffold(
         appBar: AppBar(
        title: Center(
          child: Text(
            t.activeRentalTitle,
            style: TextStyle(
              color: cs.primary,
              fontSize: screenWidth * 0.065,
              fontWeight: FontWeight.w200,
              fontFamily: 'Monoglyceride',
            ),
          ),
        ),
      ),
      backgroundColor: cs.onPrimary,
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => RentalWidget(
          rental: Rental(id: 0, userId: 0, start: DateTime(2025, 11, 11), 
          end: DateTime(2025, 12, 11), apartment:
           Apartment(id: 2, governorate: "Damascus", city: "Mazzeh", street: "dhdk", rent_price_per_night: 8769),
            status: 'accepted'), ownerView: false),
      ),
    );
  }
}