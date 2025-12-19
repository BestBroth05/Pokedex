
String pokemonThumbnailUrl(int id) {
  return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
}

int extractPokemonIdFromUrl(String url) {
  final uri = Uri.parse(url);
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  return int.parse(segments.last);
}
