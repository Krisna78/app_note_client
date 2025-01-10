import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TextFieldPage extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isLongText;
  final TextInputType textInputType;
  final int? maxLine;
  final Widget? prefixIcon;
  final bool isFilled;
  final bool isDateField;

  const TextFieldPage({
    super.key,
    required this.controller,
    required this.hintText,
    this.isLongText = false,
    this.textInputType = TextInputType.text,
    this.maxLine,
    this.prefixIcon,
    this.isFilled = true,
    this.isDateField = false,
  });

  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  static const _locale = 'id'; // Locale Indonesia
  String _oldValue = ''; // Menyimpan nilai terakhir untuk mencegah loop

  // Fungsi untuk memformat angka
  String _formatNumber(String s) {
    if (s.isEmpty) return '';
    final cleanedString = s.replaceAll('.', '');
    final formatted = NumberFormat("#,##0", _locale).format(int.tryParse(cleanedString) ?? 0);
    return formatted.replaceAll(",", ".");
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty && widget.textInputType == TextInputType.number) {
      widget.controller.text = _formatNumber(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          TextFormField(
            controller: widget.controller,
            maxLines: widget.maxLine,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.textInputType,
            inputFormatters: widget.textInputType == TextInputType.number
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            onChanged: (value) {
              if (widget.textInputType == TextInputType.number) {
                // Posisi kursor awal
                final cursorPosition = widget.controller.selection.baseOffset;

                // Nilai baru setelah diformat
                final cleanedValue = value.replaceAll('.', '');
                final formattedValue = _formatNumber(cleanedValue);

                // Hitung perubahan panjang teks
                final diff = formattedValue.length - cleanedValue.length;

                // Set teks baru dengan posisi kursor diperbaiki
                widget.controller.value = TextEditingValue(
                  text: formattedValue,
                  selection: TextSelection.collapsed(
                    offset: (cursorPosition + diff).clamp(0, formattedValue.length),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              errorStyle: const TextStyle(
                fontSize: 14,
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF80AF81)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF80AF81)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF80AF81)),
              ),
              fillColor: Colors.grey.shade100,
              filled: widget.isFilled,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            readOnly: widget.textInputType == TextInputType.datetime,
            validator: (value) {
              if (widget.isDateField) {
                return null;
              } else if (widget.isLongText) {
                if (value != null && Uri.tryParse(value)?.hasAbsolutePath == true) {
                  return null;
                }
              } else if (value == null || value.isEmpty) {
                return "Mohon wajib di isi";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
