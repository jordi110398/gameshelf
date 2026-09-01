import 'package:flutter/material.dart';
import 'package:gameshelf/core/widgets/shelf_ledge.dart';
import 'package:gameshelf/core/widgets/shelf_led_strip.dart';

/// Llista genèrica organitzada en "prestatges": files d'elements amb un fil
/// de llumets a sobre i una planxa de fusta a sota, reutilitzable a
/// qualsevol pantalla (biblioteca, amics, activitat...).
class ShelfList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Ample mínim de cada element, per calcular quantes columnes hi caben.
  final double minItemWidth;
  final int minColumns;

  /// Si és `null`, cada element ocupa la seva alçada intrínseca (útil per
  /// a contingut de mida variable, com les activitats).
  final double? itemAspectRatio;

  final double horizontalGap;
  final double rowGap;
  final EdgeInsetsGeometry padding;

  /// `true` (per defecte) quan la llista és el contingut principal
  /// desplaçable d'una pantalla. `false` quan viu dins d'un altre
  /// desplaçament (p. ex. un `ExpansionTile` dins una `ListView`), on cal
  /// que ocupi només l'alçada del seu contingut.
  final bool scrollable;

  const ShelfList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.minItemWidth = 130,
    this.minColumns = 1,
    this.itemAspectRatio,
    this.horizontalGap = 12,
    this.rowGap = 22,
    this.padding = EdgeInsets.zero,
    this.scrollable = true,
  });

  List<List<T>> _buildRows(int columns) {
    final rows = <List<T>>[];

    for (var i = 0; i < items.length; i += columns) {
      final end = (i + columns > items.length) ? items.length : i + columns;
      rows.add(items.sublist(i, end));
    }

    return rows;
  }

  Widget _buildRow(BuildContext context, List<T> rowItems, int columns) {
    return Padding(
      padding: EdgeInsets.only(bottom: rowGap),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              ShelfLedStrip(width: constraints.maxWidth),
              const SizedBox(height: 2),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < columns; i++) ...[
                    if (i > 0) SizedBox(width: horizontalGap),
                    Expanded(
                      child: i < rowItems.length
                          ? _wrapAspect(
                              itemBuilder(context, rowItems[i]),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 10),
              const ShelfLedge(),
            ],
          );
        },
      ),
    );
  }

  Widget _wrapAspect(Widget child) {
    if (itemAspectRatio == null) return child;
    return AspectRatio(aspectRatio: itemAspectRatio!, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = (constraints.maxWidth / minItemWidth).floor();

        if (columns < minColumns) {
          columns = minColumns;
        }

        final rows = _buildRows(columns);

        if (scrollable) {
          return ListView.builder(
            padding: padding,
            itemCount: rows.length,
            itemBuilder: (context, index) =>
                _buildRow(context, rows[index], columns),
          );
        }

        return Padding(
          padding: padding,
          child: Column(
            children: [
              for (final row in rows) _buildRow(context, row, columns),
            ],
          ),
        );
      },
    );
  }
}
