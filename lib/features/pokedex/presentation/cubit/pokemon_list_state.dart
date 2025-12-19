part of 'pokemon_list_cubit.dart';

enum PokemonListStatus { initial, loading, loaded, loadingMore, empty, error }

class PokemonListState extends Equatable {
  final PokemonListStatus status;
  final List<PokemonListItem> items;
  final int offset;
  final bool hasMore;
  final String? error;

  const PokemonListState({
    required this.status,
    required this.items,
    required this.offset,
    required this.hasMore,
    required this.error,
  });

  const PokemonListState.initial()
    : status = PokemonListStatus.initial,
      items = const [],
      offset = 0,
      hasMore = true,
      error = null;

  PokemonListState copyWith({
    PokemonListStatus? status,
    List<PokemonListItem>? items,
    int? offset,
    bool? hasMore,
    String? error,
  }) {
    return PokemonListState(
      status: status ?? this.status,
      items: items ?? this.items,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, offset, hasMore, error];
}
