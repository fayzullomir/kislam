import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:characters/characters.dart';

var phoneMaskFormatter = MaskTextInputFormatter(
  mask: '__ ___ __ __',
  filter: {"_": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

var birthDateMaskFormatter = MaskTextInputFormatter(
  mask: '____-__-__',
  filter: {"_": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

var docNumberMaskFormatter = MaskTextInputFormatter(
  mask: 'AA ### ## ##',
  filter: {
    "A": RegExp(r'[A-Za-z]'),
    "#": RegExp(r'[0-9]'),
  },
  type: MaskAutoCompletionType.lazy,
);

var pinflMaskFormatter = MaskTextInputFormatter(
  mask: '__ ____ ____ ____',
  filter: {"_": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

var cardNumberMaskFormatter = MaskTextInputFormatter(
  mask: '____ ____ ____ ____',
  filter: {"_": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

var cardExpiredMaskFormatter = MaskTextInputFormatter(
  mask: '__/__',
  filter: {"_": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

var priceMaskFormatter = CurrencyTextInputFormatter.currency(
  decimalDigits: 0,
  enableNegative: true,
  inputDirection: InputDirection.right,
  symbol: '',
  name: '',
  turnOffGrouping: false,
  locale: 'uz',
  customPattern: null,
);

var quantityMaskFormatter = CurrencyTextInputFormatter.currency(
  decimalDigits: 0,
  enableNegative: true,
  inputDirection: InputDirection.right,
  symbol: '',
  name: '',
  turnOffGrouping: false,
  locale: 'uz',
  customPattern: null,
);

final uzbekPhoneMaskFormatter = MaskTextInputFormatter(
  mask: '## ### ## ##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

extension CurrencyTextInputFormatterMethodExts on CurrencyTextInputFormatter {
  String? formatInt(int? value) {
    return value == null ? null : formatDouble(value.toDouble());
  }
}

extension MaskTextInputFormatterMethodExts on MaskTextInputFormatter {
  String? formatInt(int? value) {
    return value == null ? null : maskText(value.toString());
  }

  String? formatDouble(double? value) {
    return value == null ? null : maskText(value.toString());
  }

  String? formatString(String? value) {
    return value == null ? null : maskText(value);
  }
}

class UzbekPhoneInputFormatter extends TextInputFormatter {
  final MaskTextInputFormatter maskFormatter;

  UzbekPhoneInputFormatter(this.maskFormatter);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var digits = newValue.text.digitsOnly;

    // Autofill orqali 998 bilan kelsa, olib tashlash
    if (digits.startsWith('998') && digits.length >= 12) {
      digits = digits.substring(3, 12); // faqat 9 ta raqam

      maskFormatter.clear();
      final masked = maskFormatter.maskText(digits);

      return TextEditingValue(
        text: masked,
        selection: TextSelection.collapsed(offset: masked.length),
      );
    }

    return maskFormatter.formatEditUpdate(oldValue, newValue);
  }
}

class DenyEmojiFormatter extends TextInputFormatter {
  static final _emojiRegex = RegExp(
    r'[\u{1F000}-\u{1FFFF}]'
    r'|[\u{2600}-\u{27BF}]'
    r'|[\u{2300}-\u{23FF}]'
    r'|[\u{2B50}-\u{2B55}]'
    r'|[\u{203C}-\u{2049}]'
    r'|[\u{20E3}]'
    r'|[\u{FE00}-\u{FE0F}]'
    r'|[\u{200D}]'
    r'|[\u{00A9}\u{00AE}]'
    r'|[\u{E0020}-\u{E007F}]'
    r'|[\u{2190}-\u{21FF}]'
    r'|[\u{2B05}-\u{2B07}]'
    r'|[\u{25A0}-\u{25FF}]'
    r'|[\u{2934}-\u{2935}]',
    unicode: true,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newChars = newValue.text.characters;
    final buffer = StringBuffer();

    for (final char in newChars) {
      if (!_emojiRegex.hasMatch(char)) {
        buffer.write(char);
      }
    }

    final cleaned = buffer.toString();
    if (cleaned == newValue.text) return newValue;

    return newValue.copyWith(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  }
}
