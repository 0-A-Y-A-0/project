import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/providers/activeRentalsProvider.dart';
import 'package:project/providers/pastRentalsProvider.dart';
import 'package:project/widgets/rental_widget.dart';

class PastRentalsScreen extends ConsumerStatefulWidget {
  const PastRentalsScreen({super.key});

  @override
  ConsumerState<PastRentalsScreen> createState() => _PastRentalsScreenState();
}

class _PastRentalsScreenState extends ConsumerState<PastRentalsScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AppLocalizations t = AppLocalizations.of(context)!;

    final pastRentals = ref.watch(PastRentalsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.onPrimary,
        toolbarHeight: screenHeight * 0.1,
        title: Text(
          t.rentalHistory,
          style: TextStyle(
            color: cs.primary,
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.w200,
            fontFamily: 'Monoglyceride',
          ),
        ),
      ),
      backgroundColor: cs.onPrimary,
      body: pastRentals.when(
        loading: () {
          return Container(
            alignment: Alignment.center,
            height: 50,
            child: CircularProgressIndicator(),
          );
        },
        error: (_, __) {
          return Center(child: Text("there's an error, try again later :(")) ;
        },
        data: (list){
          if (list.isEmpty) {
            return Center(
              child: Text("No passed rentals yet"),
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
                onActive: false,
                ownerView: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
