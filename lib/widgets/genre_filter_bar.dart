import 'package:flutter/material.dart';
import '../api_service.dart';
import '../genre.dart';

class GenreFilterBar extends StatefulWidget {
  final int? selectedGenreId;
  final ValueChanged<int?> onSelected;

  const GenreFilterBar({
    super.key,
    required this.selectedGenreId,
    required this.onSelected,
  });

  @override
  State<GenreFilterBar> createState() => _GenreFilterBarState();
}

class _GenreFilterBarState extends State<GenreFilterBar> {
  late final Future<List<Genre>> _genres = ApiService().getGenres();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Genre>>(
      future: _genres,
      builder: (context, snapshot) {
        // Türler yüklenemezse çubuk gizlenir, film listesi yine de çalışır
        if (!snapshot.hasData) return const SizedBox.shrink();
        final genres = snapshot.data!;

        return SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              _chip('Tümü', widget.selectedGenreId == null, null),
              for (final g in genres)
                _chip(g.name, widget.selectedGenreId == g.id, g.id),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String label, bool selected, int? genreId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => widget.onSelected(genreId),
      ),
    );
  }
}