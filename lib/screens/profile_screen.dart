
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    return Scaffold(
      backgroundColor: cs.onPrimary,
      body: Center(
        child: Text("profile page let's go"),
      ),
    );
  }
}