import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/core/presentation/resources/app_colors.dart';
import 'package:pokedex/core/presentation/widgets/app_core_appbar.dart';

import '../../data/repositories/pokemon_repository.dart';
import '../cubit/pokemon_list_cubit.dart';
import '../cubit/pokemon_detail_cubit.dart';
import '../widgets/pokemon_tile.dart';
import 'pokemon_detail_page.dart';

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  final _scrollController = ScrollController();
  int? _selectedId; // usado en desktop master-detail

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= (max * 0.8)) {
      context.read<PokemonListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isDesktop(double width) => width >= 900;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PokemonRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PokemonListCubit(repo: repo)..loadFirstPage(),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = _isDesktop(constraints.maxWidth);

          return Scaffold(
            appBar: AppCoreAppBar(title: 'Pokédex', showBack: false),
            body: desktop
                ? _DesktopLayout(
                    selectedId: _selectedId,
                    onSelect: (id) {
                      setState(() => _selectedId = id);
                    },
                  )
                : _MobileLayout(scrollController: _scrollController),
          );
        },
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final ScrollController scrollController;
  const _MobileLayout({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonListCubit, PokemonListState>(
      builder: (context, state) {
        if (state.status == PokemonListStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == PokemonListStatus.error) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.error ?? 'Error'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      context.read<PokemonListCubit>().loadFirstPage(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state.status == PokemonListStatus.empty) {
          return const Center(child: Text('Sin resultados'));
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: state.items.length + 1,
          itemBuilder: (context, index) {
            if (index == state.items.length) {
              if (state.status == PokemonListStatus.loadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!state.hasMore) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('Fin del listado')),
                );
              }
              return const SizedBox.shrink();
            }

            final item = state.items[index];
            return PokemonTile(
              index: index,
              item: item,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PokemonDetailPage(pokemonId: item.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final int? selectedId;
  final void Function(int id) onSelect;

  const _DesktopLayout({required this.selectedId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PokemonRepository>();

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: BlocBuilder<PokemonListCubit, PokemonListState>(
            builder: (context, state) {
              if (state.status == PokemonListStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == PokemonListStatus.error) {
                return Center(child: Text(state.error ?? 'Error'));
              }
              if (state.items.isEmpty) {
                return const Center(child: Text('Sin resultados'));
              }

              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, i) {
                  final item = state.items[i];
                  final selected = item.id == selectedId;
                  return PokemonTile(
                    index: i,
                    item: item,
                    selected: selected,
                    onTap: () => onSelect(item.id),
                  );
                },
              );
            },
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 6,
          child: selectedId == null
              ? const Center(child: Text('Selecciona un Pokémon'))
              : BlocProvider(
                  key: ValueKey('detail-$selectedId'),
                  create: (_) =>
                      PokemonDetailCubit(repo: repo)..load(selectedId!),
                  child: const _DetailPane(),
                ),
        ),
      ],
    );
  }
}

class _DetailPane extends StatelessWidget {
  const _DetailPane();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
      builder: (context, state) {
        if (state.status == PokemonDetailStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == PokemonDetailStatus.error) {
          return Center(child: Text(state.error ?? 'Error'));
        }
        final d = state.detail;
        if (d == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(24),
          child: PokemonDetailContent(detail: d),
        );
      },
    );
  }
}
