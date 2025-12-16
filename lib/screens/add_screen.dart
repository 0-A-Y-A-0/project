
import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    return Scaffold(
      backgroundColor: cs.onPrimary,
      body: Center(
        child: Text("add page let's go"),
      ),
    );
  }
}