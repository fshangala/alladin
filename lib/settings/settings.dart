import 'package:alladin/core/functions.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Settings'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(),
      ),
    );
  }
}
