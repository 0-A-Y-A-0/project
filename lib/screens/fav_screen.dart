
import 'package:flutter/material.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    return Scaffold(
      backgroundColor: cs.onPrimary,
      body: Center(
        child: Text("fav page let's go"),
      ),
    );
  }
}