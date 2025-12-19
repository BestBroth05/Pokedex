import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/pokemon_list_item.dart';
import '../../data/repositories/pokemon_repository.dart';

part 'pokemon_list_state.dart';

class PokemonListCubit extends Cubit<PokemonListState> {
  final PokemonRepository repo;

  PokemonListCubit({required this.repo})
    : super(const PokemonListState.initial());

  static const int _pageSize = 30;

  Future<void> loadFirstPage() async {
    emit(
      state.copyWith(
        status: PokemonListStatus.loading,
        items: [],
        offset: 0,
        hasMore: true,
        error: null,
      ),
    );
    await _loadNextInternal();
  }

  Future<void> loadMore() async {
    if (state.status == PokemonListStatus.loadingMore) return;
    if (!state.hasMore) return;
    if (state.status == PokemonListStatus.loading) return;

    emit(state.copyWith(status: PokemonListStatus.loadingMore, error: null));
    await _loadNextInternal();
  }

  Future<void> _loadNextInternal() async {
    try {
      final items = await repo.fetchPokemonPage(
        limit: _pageSize,
        offset: state.offset,
      );
      final merged = [...state.items, ...items];

      emit(
        state.copyWith(
          status: merged.isEmpty
              ? PokemonListStatus.empty
              : PokemonListStatus.loaded,
          items: merged,
          offset: state.offset + _pageSize,
          hasMore: items.length == _pageSize,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: PokemonListStatus.error, error: e.toString()),
      );
    }
  }
}
