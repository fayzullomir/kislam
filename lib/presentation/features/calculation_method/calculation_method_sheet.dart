import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/data/datasource/preference/calculation_method_preferences.dart';
import 'package:koreaislam/domain/models/calculation_method/calculation_method.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

/// Bottom sheet for picking the prayer-time calculation method. Reads +
/// writes through [CalculationMethodPreferences] singleton — same pattern
/// as [MadhabSheet] / [QuranTranslationSheet]. Closes immediately on
/// selection so the home countdown rebuilds straight away.
class CalculationMethodSheet extends StatefulWidget {
  const CalculationMethodSheet({super.key});

  @override
  State<CalculationMethodSheet> createState() => _CalculationMethodSheetState();
}

class _CalculationMethodSheetState extends State<CalculationMethodSheet> {
  final CalculationMethodPreferences _prefs =
      getIt<CalculationMethodPreferences>();
  late CalculationMethod _selected = _prefs.method;

  @override
  Widget build(BuildContext context) {
    return NoorSheetScaffold(
      children: [
        NoorSheetHeader(
          eyebrow: Strings.calculationMethodSheetEyebrow,
          subtitle: Strings.calculationMethodSheetSubtitle,
        ),
        const SizedBox(height: 8),
        Container(
          color: context.noor.surface,
          child: Column(
            children: [
              for (var i = 0; i < CalculationMethod.values.length; i++) ...[
                NoorSheetSelectableRow(
                  title: CalculationMethod.values[i].localizedName,
                  selected: _selected == CalculationMethod.values[i],
                  onTap: () => _select(CalculationMethod.values[i]),
                ),
                if (i != CalculationMethod.values.length - 1)
                  const NoorSheetRowDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _select(CalculationMethod method) async {
    setState(() => _selected = method);
    await _prefs.setMethod(method);
    if (mounted) Navigator.of(context).maybePop();
  }
}
