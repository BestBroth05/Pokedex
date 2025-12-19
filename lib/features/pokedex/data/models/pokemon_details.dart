import 'package:equatable/equatable.dart';

class PokemonDetail extends Equatable {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final String? imageUrl;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.imageUrl,
  });

  factory PokemonDetail.fromApi(Map<String, dynamic> json) {
    final types = (json['types'] as List? ?? [])
        .map((e) => ((e as Map)['type'] as Map?)?['name'] as String?)
        .whereType<String>()
        .toList();

    final sprites = (json['sprites'] as Map?)?.cast<String, dynamic>();
    final other = (sprites?['other'] as Map?)?.cast<String, dynamic>();
    final artwork = (other?['official-artwork'] as Map?)
        ?.cast<String, dynamic>();
    final image = artwork?['front_default'] as String?;

    return PokemonDetail(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
      height: (json['height'] as num?)?.toInt() ?? 0,
      weight: (json['weight'] as num?)?.toInt() ?? 0,
      types: types,
      imageUrl: image,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'height': height,
    'weight': weight,
    'types': types,
    'imageUrl': imageUrl,
  };

  factory PokemonDetail.fromCache(Map<String, dynamic> json) {
    return PokemonDetail(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
      height: (json['height'] as num?)?.toInt() ?? 0,
      weight: (json['weight'] as num?)?.toInt() ?? 0,
      types: (json['types'] as List? ?? []).whereType<String>().toList(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, height, weight, types, imageUrl];
}
