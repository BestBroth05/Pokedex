import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/core/presentation/resources/app_colors.dart';
import 'package:pokedex/core/presentation/resources/app_text_styles.dart';
import '../../data/models/pokemon_list_item.dart';

class PokemonTile extends StatelessWidget {
  final PokemonListItem item;
  final VoidCallback onTap;
  final bool selected;
  final int index;

  const PokemonTile({
    super.key,
    required this.item,
    required this.onTap,
    this.selected = false,
    required this.index,
  });

  Color _backgroundColor(BuildContext context) {
    if (selected) {
      // cuando está seleccionado, este color manda sobre par/impar
      return AppColors.primary300.withValues(alpha: 30);
    }

    // zebra: pares/impares
    return index.isEven ? AppColors.primary200 : AppColors.primary100;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      color: _backgroundColor(context),
      child: ListTile(
        selected: selected,
        leading: CachedNetworkImage(
          imageUrl: item.thumbnailUrl,
          width: 48,
          height: 48,
          placeholder: (_, __) => const SizedBox(
            width: 48,
            height: 48,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
        ),
        title: Text(
          item.name,
          style: AppTextStyles.body.copyWith(color: AppColors.primary900),
        ),
        subtitle: Text(
          '#${item.id}',
          style: AppTextStyles.body.copyWith(
            color: AppColors.primary900,
            fontWeight: FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
