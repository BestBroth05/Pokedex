/// Sprite oficial (rápido y estable para thumbnails).
/// Usamos el ID para evitar hacer request de detalle por cada item.
String pokemonThumbnailUrl(int id) {
  // Puedes cambiar a otros sprites si quieres
  return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
}

/// Extrae ID desde la URL del listado:
/// "https://pokeapi.co/api/v2/pokemon/25/" -> 25
int extractPokemonIdFromUrl(String url) {
  final uri = Uri.parse(url);
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  return int.parse(segments.last);
}
