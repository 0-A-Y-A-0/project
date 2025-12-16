
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme ;
    return Scaffold(
      backgroundColor: cs.onPrimary,
      body: Center(
        child: Text("chat page let's go"),
      ),
    );
  }
}