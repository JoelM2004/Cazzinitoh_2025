import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';

/// Input de fecha con date picker integrado.
///
/// Ejemplo:
///   AppDateField(
///     label: 'Fecha de nacimiento',
///     selected: _fecha,
///     onChanged: (d) => setState(() => _fecha = d),
///   )
class AppDateField extends StatelessWidget {
  final String label;
  final String placeholder;
  final DateTime? selected;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(String?)? validator;

  const AppDateField({
    Key? key,
    this.label = 'Fecha',
    this.placeholder = 'aaaa-mm-dd',
    this.selected,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.validator,
  }) : super(key: key);

  String _format(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final initial = selected ?? DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? now,
      helpText: 'Seleccioná la fecha',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.purplePrimary,
            onPrimary: Colors.white,
            surface: AppColors.purpleCard,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = selected != null ? _format(selected!) : '';
    final ctrl = TextEditingController(text: displayText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.purple300),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.purple300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () => _pick(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: ctrl,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              validator: validator,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(color: AppColors.purple300.withOpacity(0.4)),
                filled: true,
                fillColor: AppColors.purpleCardBorder.withOpacity(0.4),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                suffixIcon: const Icon(Icons.expand_more_rounded, color: AppColors.purpleAccent),
                border: _border(AppColors.purpleBorder.withOpacity(0.4)),
                enabledBorder: _border(AppColors.purpleBorder.withOpacity(0.4)),
                focusedBorder: _border(AppColors.purpleAccent, width: 1.5),
                errorBorder: _border(AppColors.red500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1.0}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: width),
      );
}
