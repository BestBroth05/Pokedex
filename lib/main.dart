import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/config/env.dart';

import 'app.dart';
import 'core/cache/local_cache.dart';
import 'core/network/poke_api_client.dart';
import 'features/pokedex/data/repositories/pokemon_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await LocalCache.init();
  await dotenv.load(fileName: Environment.fileName);
  final api = PokeApiClient();
  final cache = LocalCache();
  final repo = PokemonRepository(api: api, cache: cache);

  runApp(RepositoryProvider.value(value: repo, child: const App()));
}
