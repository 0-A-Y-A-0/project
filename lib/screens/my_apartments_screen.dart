import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/my_apartments_provider.dart';

import '../generated/l10n/app_localizations.dart';
import '../widgets/apartment_widget.dart';

class MyApartmentsScreen extends ConsumerStatefulWidget {
  const MyApartmentsScreen({super.key});

  @override
  ConsumerState<MyApartmentsScreen> createState() => _MyApartmentsScreenState();
}

class _MyApartmentsScreenState extends ConsumerState<MyApartmentsScreen> {

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AppLocalizations t = AppLocalizations.of(context)!;

    final myApts = ref.watch(MyApartmentsProvider);

    return Scaffold(
      backgroundColor: cs.onPrimary,
      appBar: AppBar(
        backgroundColor: cs.onPrimary,
        toolbarHeight: screenHeight * 0.1,
        title: Text(
          t.myApartments,
          style: TextStyle(
            color: cs.primary,
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.w200,
            fontFamily: 'Monoglyceride',
          ),
        ),
      ),
      body: myApts.when(
        loading: () {
          return Container(
            alignment: Alignment.center,
            height: 50,
            child: CircularProgressIndicator(),
          );
        },
        error: (_, __) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(MyApartmentsProvider);
            },
            child: ListView(
              children: [
                Container(
                    height: screenHeight - 200,
                    child: Center(child: Text(t.theresAnError))
                )
              ],
            ),
          );
        },
        data: (list){
          if (list.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(MyApartmentsProvider);
              },
              child: ListView(
                children: [
                  Container(
                      height: screenHeight - 200,
                      child: Center(child: Text(t.youDidntPostAnyApartmentYet))
                  )
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(MyApartmentsProvider);
            },
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ApartmentWidget(
                  apartment: list[index] ,
                  height: 200,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
