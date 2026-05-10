import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/data/datasource/preference/madhab_preferences.dart';
import 'package:koreaislam/domain/models/madhab/madhab.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

/// Bottom sheet that lets the user pick their madhab. Reads + writes
/// directly through [MadhabPreferences] — no Cubit needed because the
/// preference exposes a [ValueNotifier] that profile rows listen to.
class MadhabSheet extends StatefulWidget {
  const MadhabSheet({super.key});

  @override
  State<MadhabSheet> createState() => _MadhabSheetState();
}

class _MadhabSheetState extends State<MadhabSheet> {
  final MadhabPreferences _prefs = getIt<MadhabPreferences>();
  late Madhab _selected = _prefs.madhab;

  @override
  Widget build(BuildContext context) {
    return NoorSheetScaffold(
      children: [
        NoorSheetHeader(
          eyebrow: Strings.madhabSheetEyebrow,
          subtitle: Strings.madhabSheetSubtitle,
        ),
        const SizedBox(height: 8),
        Container(
          color: context.noor.surface,
          child: Column(
            children: [
              for (var i = 0; i < Madhab.values.length; i++) ...[
                NoorSheetSelectableRow(
                  title: Madhab.values[i].localizedName,
                  selected: _selected == Madhab.values[i],
                  onTap: () => _select(Madhab.values[i]),
                ),
                if (i != Madhab.values.length - 1) const NoorSheetRowDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _select(Madhab madhab) async {
    setState(() => _selected = madhab);
    await _prefs.setMadhab(madhab);
    if (mounted) Navigator.of(context).maybePop();
  }
}
