import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PreviousMatchScreen extends StatelessWidget {
  static const routeName = '/previous_match';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.primaryBlue,
        title: const Text("Partidas"),
      ),
      body: Container(
        child: const Text("Partidas"),
      ),
    );
  }
}
