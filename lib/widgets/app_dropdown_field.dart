import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DropdownOption<T> {
  const DropdownOption({required this.value, required this.label});

  final T value;
  final String label;
}

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.options,
    this.initialValue,
    this.icon,
    this.validator,
    this.onChanged,
    this.onSaved,
  });

  final String label;
  final List<DropdownOption<T>> options;
  final T? initialValue;
  final IconData? icon;
  final String? Function(T?)? validator;
  final ValueChanged<T?>? onChanged;
  final FormFieldSetter<T>? onSaved;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      builder: (state) {
        return InputDecorator(
          decoration: AppTheme.input(label: label, icon: icon).copyWith(
            errorText: state.errorText,
          ),
          isEmpty: state.value == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: state.value,
              isExpanded: true,
              isDense: true,
              items: options
                  .map(
                    (option) => DropdownMenuItem<T>(
                      value: option.value,
                      child: Text(
                        option.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                state.didChange(value);
                onChanged?.call(value);
              },
            ),
          ),
        );
      },
    );
  }
}
