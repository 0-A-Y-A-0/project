import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/models/Apartment.dart';
import 'package:project/models/Rental.dart';
import 'package:project/providers/activeRentalsProvider.dart';
import 'package:project/widgets/rental_widget.dart';

class ActiveRentalsScreen extends ConsumerStatefulWidget {
  const ActiveRentalsScreen({super.key});

  @override
  ConsumerState<ActiveRentalsScreen> createState() => _ActiveRentalsScreenState();
}

class _ActiveRentalsScreenState extends ConsumerState<ActiveRentalsScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    final AppLocalizations t = AppLocalizations.of(context)!;

    final activeRentals = ref.watch(ActiveRentalsProvider);

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
      body: activeRentals.when(
        loading: () {
          return Container(
            alignment: Alignment.center,
            height: 50,
            child: CircularProgressIndicator(),
          );
        },
        error: (e, __) {

          return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(ActiveRentalsProvider);
              },
              child: Center(child: Text("there's an error, try again later :("))
          ) ;
        },
        data: (list){
          if (list.isEmpty) {
            return Center(
              child: Text("No active rentals yet"),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(ActiveRentalsProvider);
            },
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => RentalWidget(
                rental: list[index],
                ownerView: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
