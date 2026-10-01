import 'package:flutter/material.dart';

import '../theme.dart';

/// Opens [sheet] as a modal bottom sheet with Tidal's standard shape
/// (rounded top corners, card background, resizes above the keyboard).
Future<T?> showTidalSheet<T>(BuildContext context, Widget sheet) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: TidalColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(TidalRadius.large),
      ),
    ),
    builder: (context) => sheet,
  );
}

/// Shared chrome for every log sheet: a title, a close ("X") button, the
/// sheet's own content, and a Save button at the bottom.
class SheetScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  // Null disables the Save button (used both while saving and when there's
  // nothing valid to save yet).
  final VoidCallback? onSave;
  final bool saving;

  const SheetScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.onSave,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onSave,
            child: saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save'),
          ),
        ],
      ),
    );
  }
}

/// A round pastel chip used to pick one value out of a few options, e.g. a
/// flow level, a mood, or a pain level.
class OptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedBackground;
  final Color selectedForeground;
  final VoidCallback onTap;

  const OptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.selectedBackground,
    required this.selectedForeground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      backgroundColor: TidalColors.background,
      selectedColor: selectedBackground,
      side: BorderSide(
        color: selected ? selectedBackground : TidalColors.border,
      ),
      labelStyle: TextStyle(
        color: selected ? selectedForeground : TidalColors.text,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

void showSheetError(BuildContext context, Object error) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('Could not save: $error')));
}
