import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mm_inventory_web/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'custom_field_model.dart';

enum FormType {
  text,
  number,
  password,
  datetime,
  dropdown,
  // Add more types as needed
}

class CustomField extends StackedView<CustomFieldModel> {
  const CustomField({
    required this.label,
    required this.formType,
    this.controller,
    super.key,
    this.validator,
    this.isRequired = false,
    this.inputFormatters,
    this.readOnly = false,
    // Dropdown-specific
    this.dropdownItems,
    this.onDropdownChanged,
    this.dropdownValue,
    // Datetime-specific
    this.onDateTimeChanged,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    // Text-specific
    this.minLines,
    this.maxLines,
    this.hintText,
  });

  final String label;
  final FormType formType;
  final TextEditingController? controller;
  final FormFieldValidator<dynamic>? validator;
  final bool isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;

  // Dropdown-specific
  final List<DropdownMenuItem<dynamic>>? dropdownItems;
  final ValueChanged<dynamic>? onDropdownChanged;
  final dynamic dropdownValue;

  // Datetime-specific
  final ValueChanged<DateTime?>? onDateTimeChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  final int? minLines;
  final int? maxLines;
  final String? hintText;

  List<DropdownMenuItem<dynamic>> _dedupeDropdownItems(
    List<DropdownMenuItem<dynamic>>? items,
  ) {
    if (items == null || items.isEmpty) return const [];
    final seen = <dynamic>{};
    final deduped = <DropdownMenuItem<dynamic>>[];
    for (final item in items) {
      if (seen.add(item.value)) {
        deduped.add(item);
      }
    }
    return deduped;
  }

  dynamic _safeDropdownInitialValue(
    List<DropdownMenuItem<dynamic>> items,
    dynamic value,
  ) {
    if (value is String && value.trim().isEmpty) return null;
    if (value == null) return null;
    final matches = items.where((item) => item.value == value).length;
    return matches == 1 ? value : null;
  }

  @override
  Widget builder(
    BuildContext context,
    CustomFieldModel viewModel,
    Widget? child,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(context),
          Expanded(child: _buildField(context)),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Widget _buildField(BuildContext context) {
    final fieldColor = readOnly ? kcMediumGrey : Colors.white;
    final textColor = readOnly ? kcMediumGrey : Colors.black;

    switch (formType) {
      case FormType.number:
      case FormType.text:
      case FormType.password:
        return _buildTextField(context, fieldColor, textColor);
      case FormType.datetime:
        return _buildDateTimeField(context, fieldColor, textColor);
      case FormType.dropdown:
        return _buildDropdownField(context, fieldColor, textColor);
    }
  }

  Widget _buildTextField(
    BuildContext context,
    Color fieldColor,
    Color textColor,
  ) {
    TextInputType keyboardType;
    bool obscureText = false;
    switch (formType) {
      case FormType.number:
        keyboardType = TextInputType.number;
        break;
      case FormType.password:
        keyboardType = TextInputType.text;
        obscureText = true;
        break;
      default:
        keyboardType = TextInputType.text;
    }
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      controller: controller,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: !readOnly,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
      minLines: minLines,
      maxLines: maxLines,
      decoration: _inputDecoration(
        context: context,
        fillColor: fieldColor,
        suffixIcon: isRequired
            ? const SizedBox(
                width: 28,
                child: Center(
                  child: Icon(
                    Icons.star,
                    color: Colors.red,
                    size: 10,
                  ),
                ),
              )
            : null,
        hintText: hintText,
      ),
    );
  }

  Widget _buildDateTimeField(
    BuildContext context,
    Color fieldColor,
    Color textColor,
  ) {
    // Ensure controller has text if it's empty and we have an initialDate
    if (controller != null && controller!.text.isEmpty && initialDate != null) {
      controller!.text = '${initialDate!.toLocal()}'.split(' ')[0];
    }

    return InkWell(
      onTap: readOnly
          ? null
          : () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: initialDate ?? DateTime.now(),
                firstDate: firstDate ?? DateTime(1900),
                lastDate: lastDate ?? DateTime(2100),
              );
              if (picked != null) {
                controller?.text = '${picked.toLocal()}'.split(' ')[0];
                if (onDateTimeChanged != null) {
                  onDateTimeChanged!(picked);
                }
              }
            },
      child: IgnorePointer(
        child: TextFormField(
          autovalidateMode: AutovalidateMode.always,
          controller: controller,
          validator: validator,
          readOnly: true,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: textColor),
          decoration: _inputDecoration(
            context: context,
            fillColor: fieldColor,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today),
                if (isRequired)
                  const SizedBox(
                    width: 28,
                    child: Center(
                      child: Icon(
                        Icons.star,
                        color: Colors.red,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    Color fieldColor,
    Color textColor,
  ) {
    final items = _dedupeDropdownItems(dropdownItems);
    final safeInitialValue = _safeDropdownInitialValue(items, dropdownValue);
    return DropdownButtonFormField<dynamic>(
      initialValue: safeInitialValue,
      items: items.isEmpty ? null : items,
      onChanged: readOnly ? null : onDropdownChanged,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
      decoration: _inputDecoration(
        context: context,
        fillColor: fieldColor,
        suffixIcon: isRequired
            ? const SizedBox(
                width: 28,
                child: Center(
                  child: Icon(
                    Icons.star,
                    color: Colors.red,
                    size: 10,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    Color? fillColor,
    Widget? suffixIcon,
    String? hintText,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: fillColor ?? Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kcMediumGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kcMediumGrey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kcMediumGrey),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodySmall,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
    );
  }

  @override
  CustomFieldModel viewModelBuilder(BuildContext context) => CustomFieldModel();
}
