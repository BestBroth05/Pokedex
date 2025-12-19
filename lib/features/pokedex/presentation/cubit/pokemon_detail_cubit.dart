import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/pokemon_details.dart';
import '../../data/repositories/pokemon_repository.dart';

part 'pokemon_details_state.dart';

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  final PokemonRepository repo;

  PokemonDetailCubit({required this.repo})
    : super(const PokemonDetailState.initial());

  Future<void> load(int id) async {
    emit(const PokemonDetailState.loading());
    try {
      final detail = await repo.fetchPokemonDetail(id);
      emit(PokemonDetailState.loaded(detail));
    } catch (e) {
      emit(PokemonDetailState.error(e.toString()));
    }
  }
}
