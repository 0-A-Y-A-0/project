import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/favorites_provider.dart';

import '../generated/l10n/app_localizations.dart';
import '../widgets/apartment_widget.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AppLocalizations t = AppLocalizations.of(context)!;

    final favorites = ref.watch(FavoritesProvider);

    return Scaffold(
      backgroundColor: cs.onPrimary,
      appBar: AppBar(
        backgroundColor: cs.onPrimary,
        toolbarHeight: screenHeight * 0.1,
        title: Text(
          t.favorites,
          style: TextStyle(
            color: cs.primary,
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.w200,
            fontFamily: 'Monoglyceride',
          ),
        ),
      ),
      body: favorites.when(
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
              child: Text("No favorite apartments added yet"),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ApartmentWidget(
                apartment: list[index] ,
                height: 200,
              );
            },
          );
        },
      ),
    );
  }
}
