part of 'pokemon_detail_cubit.dart';

enum PokemonDetailStatus { initial, loading, loaded, error }

class PokemonDetailState extends Equatable {
  final PokemonDetailStatus status;
  final PokemonDetail? detail;
  final String? error;

  const PokemonDetailState({
    required this.status,
    required this.detail,
    required this.error,
  });

  const PokemonDetailState.initial()
    : status = PokemonDetailStatus.initial,
      detail = null,
      error = null;

  const PokemonDetailState.loading()
    : status = PokemonDetailStatus.loading,
      detail = null,
      error = null;

  const PokemonDetailState.loaded(PokemonDetail d)
    : status = PokemonDetailStatus.loaded,
      detail = d,
      error = null;

  const PokemonDetailState.error(String msg)
    : status = PokemonDetailStatus.error,
      detail = null,
      error = msg;

  @override
  List<Object?> get props => [status, detail, error];
}
