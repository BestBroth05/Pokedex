import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/core/presentation/resources/app_colors.dart';
import 'package:pokedex/core/presentation/resources/app_text_styles.dart';
import 'package:pokedex/core/presentation/widgets/app_core_appbar.dart';

import '../../data/repositories/pokemon_repository.dart';
import '../cubit/pokemon_detail_cubit.dart';
import '../../data/models/pokemon_details.dart';

class PokemonDetailPage extends StatelessWidget {
  final int pokemonId;
  const PokemonDetailPage({super.key, required this.pokemonId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PokemonRepository>();

    return BlocProvider(
      create: (_) => PokemonDetailCubit(repo: repo)..load(pokemonId),
      child: Scaffold(
        appBar: AppCoreAppBar(title: 'Pokédex'),
        body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
          builder: (context, state) {
            if (state.status == PokemonDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == PokemonDetailStatus.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.error ?? 'Error'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () =>
                          context.read<PokemonDetailCubit>().load(pokemonId),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }
            final d = state.detail;
            if (d == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.all(24),
              child: PokemonDetailContent(detail: d),
            );
          },
        ),
      ),
    );
  }
}

class PokemonDetailContent extends StatelessWidget {
  final PokemonDetail detail;
  const PokemonDetailContent({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          '${detail.name.toUpperCase()}  #${detail.id}',
          style: AppTextStyles.subTitle.copyWith(color: AppColors.primary900),
        ),
        const SizedBox(height: 16),
        if (detail.imageUrl != null)
          Center(
            child: Image.network(
              detail.imageUrl!,
              height: 220,
              fit: BoxFit.contain,
            ),
          ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: detail.types
              .map(
                (t) => Chip(
                  backgroundColor: AppColors.primary400,
                  label: Text(
                    t,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary50,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Card(
          color: AppColors.primary400,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _row('Height', '${detail.height}'),
                const SizedBox(height: 8),
                _row('Weight', '${detail.weight}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(String k, String v) {
    return Row(
      children: [
        Expanded(child: Text(k, style: AppTextStyles.body)),
        Text(v, style: AppTextStyles.body),
      ],
    );
  }
}
