import 'package:flutter/material.dart';
import 'package:pokedex/core/presentation/resources/app_colors.dart';
import 'package:pokedex/features/pokedex/presentation/pages/pokemon_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: AppColors.primary100,
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      home: const PokedexPage(),
    );
  }
}
