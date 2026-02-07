
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/requestsProvider.dart';

import '../generated/l10n/app_localizations.dart';
import '../widgets/rental_widget.dart';

class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});

  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AppLocalizations t = AppLocalizations.of(context)!;

    final requests = ref.watch(RequestsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.onPrimary,
        toolbarHeight: screenHeight * 0.1,
        title: Text(
          t.rentalRequests,
          style: TextStyle(
            color: cs.primary,
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.w200,
            fontFamily: 'Monoglyceride',
          ),
        ),
      ),
      backgroundColor: cs.onPrimary,
      body: requests.when(
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
                ref.invalidate(RequestsProvider);
              },
              child: Center(child: Text(t.theresAnError))
          ) ;
        },
        data: (list){
          if (list.isEmpty) {
            return Center(
              child: Text(t.noRentalRequestsYet),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(RequestsProvider);
            },
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => RentalWidget(
                rental: list[index],
                onActive: false,
                ownerView: true,
              ),
            ),
          );
        }
      )
    );
  }
}
