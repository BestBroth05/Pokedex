import 'package:equatable/equatable.dart';
import '../../../../core/utils/pokemon_image.dart';

class PokemonListItem extends Equatable {
  final int id;
  final String name;

  const PokemonListItem({required this.id, required this.name});

  String get thumbnailUrl => pokemonThumbnailUrl(id);

  factory PokemonListItem.fromListJson(Map<String, dynamic> json) {
    final name = (json['name'] as String?) ?? '';
    final url = (json['url'] as String?) ?? '';
    final id = extractPokemonIdFromUrl(url);
    return PokemonListItem(id: id, name: name);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory PokemonListItem.fromCacheJson(Map<String, dynamic> json) {
    return PokemonListItem(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}
