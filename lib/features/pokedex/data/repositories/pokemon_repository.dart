import '../../../../core/cache/local_cache.dart';
import '../../../../core/network/poke_api_client.dart';
import '../models/pokemon_list_item.dart';
import '../models/pokemon_details.dart';

class PokemonRepository {
  final PokeApiClient api;
  final LocalCache cache;

  PokemonRepository({required this.api, required this.cache});

  String _listKey(int limit, int offset) => 'list:limit=$limit:offset=$offset';
  String _detailKey(int id) => 'detail:id=$id';

  Future<List<PokemonListItem>> fetchPokemonPage({
    required int limit,
    required int offset,
  }) async {
    final key = _listKey(limit, offset);

    try {
      final json = await api.getJson(
        '/pokemon',
        query: {'limit': '$limit', 'offset': '$offset'},
      );

      // cachear respuesta “normalizada” para offline
      final items = (json['results'] as List? ?? [])
          .whereType<Map>()
          .map((e) => PokemonListItem.fromListJson(e.cast<String, dynamic>()))
          .toList();

      await cache.putJson(key, {
        'items': items.map((e) => e.toJson()).toList(),
      });

      return items;
    } catch (_) {
      // fallback offline
      final cached = cache.getJson(key);
      if (cached == null) rethrow;

      final items = (cached['items'] as List? ?? [])
          .whereType<Map>()
          .map((e) => PokemonListItem.fromCacheJson(e.cast<String, dynamic>()))
          .toList();

      return items;
    }
  }

  Future<PokemonDetail> fetchPokemonDetail(int id) async {
    final key = _detailKey(id);

    try {
      final json = await api.getJson('/pokemon/$id/');
      final detail = PokemonDetail.fromApi(json);

      await cache.putJson(key, detail.toJson());
      return detail;
    } catch (_) {
      final cached = cache.getJson(key);
      if (cached == null) rethrow;
      return PokemonDetail.fromCache(cached);
    }
  }
}
