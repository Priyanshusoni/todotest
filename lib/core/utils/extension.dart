import 'dart:math';
import 'package:todo/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DoubleHelper on double {
  double toTwoDigitDecimal() {
    return double.parse(toStringAsFixed(2));
  }
}

extension StringHelper on String {
  String toCapitalize() {
    return isEmpty ? '' : replaceRange(0, 1, this[0].toUpperCase());
  }

  double toDouble() {
    return isEmpty ? 0 : (double.tryParse(this) ?? 0);
  }

  int toInt() {
    return isEmpty ? 0 : int.tryParse(this) ?? 0;
  }

  DateTime toDateTime() {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(this, true).toLocal();
  }

  DateTime toDateTime2() {
    return DateFormat("yyyy-MM-dd HH:mm").parse(this, false).toLocal();
  }

  DateTime toDate() {
    return DateFormat("yyyy-MM-dd").parse(this);
  }

  DateTime toMonth() {
    return DateFormat("yyyy-MM").parse(this);
  }

  TimeOfDay toTime() {
    return TimeOfDay(
      hour: split(':')[0].toInt(),
      minute: split(':')[1].toInt(),
    );
  }

  String toShort() {
    if (isEmpty) {
      return this;
    }
    List<String> words = split(' ').toList();
    words.removeWhere((element) => element.isEmpty);
    return words.fold('', (pre, cur) => pre + cur[0]).toUpperCase();
  }

  bool get isPlusCode => contains('+');

  Color toHexColor() {
    String hex = replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex"; // Add full opacity if not specified
    }
    return Color(int.parse("0x$hex"));
  }
}

extension DateHelper on DateTime {
  String toHHMM() {
    return DateFormat('hh:mm a').format(this);
  }

  String toWeekDay() {
    return DateFormat('EEE').format(this).toUpperCase();
  }

  String toMonth() {
    return DateFormat('MMM').format(this).toUpperCase();
  }

  String toDDMMYY() {
    return DateFormat('dd MMM, yyyy').format(this);
  }

  String toMMMYY() {
    return DateFormat('MMMM, yyyy').format(this);
  }

  String toYYMMDD() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toYYMM() {
    return DateFormat('yyyy-MM').format(this);
  }

  String toDDMMYYHHMM() {
    return DateFormat('dd MMM, yyyy | hh:mm a').format(this);
  }

  String toDDEEE() {
    return DateFormat('dd MMM, EEE').format(this).toUpperCase();
  }

  String toAgo() {
    Duration since = DateTime.now()
        .add(Duration(hours: Random(1).nextInt(18)))
        .difference(this);
    if (since.inSeconds < 60) {
      return "${since.inSeconds} seconds ago";
    }
    if (since.inSeconds < 3600) {
      return "${since.inMinutes} minutes ago";
    }
    if (since.inSeconds < 86400) {
      return "${since.inHours} hours ago";
    }
    if (since.inSeconds < 172800) {
      return 'Yesterday';
    }
    return toDDMMYY();
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String getTimeHeader() {
    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(year, month, day);

    final days = currentDate.difference(messageDate).inDays;
    if (days > 1) {
      return DateFormat('MMM d, yyyy').format(this);
    } else if (days > 0) {
      return 'Yesterday';
    } else {
      return 'Today';
    }
  }
}

extension DateRangeHelper on DateTimeRange {
  String toDDMMYYHHMM() {
    final dateFormat = DateFormat('dd MMM, yy HH:mm');
    return '${dateFormat.format(start)} - ${dateFormat.format(end)}';
  }

  String toDDMMYY() {
    final dateFormat = DateFormat('dd MMM, yyyy');
    return start.toDDMMYY() == end.toDDMMYY()
        ? dateFormat.format(start)
        : '${dateFormat.format(start)} - ${dateFormat.format(end)}';
  }

  String toMMYY() {
    final dateFormat = DateFormat('MMM, yyyy');
    return start.toDDMMYY() == end.toDDMMYY()
        ? dateFormat.format(start)
        : '${dateFormat.format(start)} - ${dateFormat.format(end)}';
  }

  int totalDays() {
    return end.difference(start).inDays + 1;
  }

  bool is30DaysDiff() {
    return (end.difference(start).inDays + 1) <= 30;
  }
}

extension TimeHelper on TimeOfDay {
  String toTime() {
    String h = hour % 12 == 0
        ? '12'
        : hour % 12 < 10
        ? '0${hour % 12}'
        : '${hour % 12}';
    String m = minute < 10 ? '0$minute' : '$minute';
    return '$h:$m ${period.name.toUpperCase()}';
  }

  String toHHMM() {
    String h = hour < 10 ? '0$hour' : '$hour';
    String m = minute < 10 ? '0$minute' : '$minute';
    return '$h:$m:00';
  }

  int hourDiff(TimeOfDay time) {
    final diff = time.hour - hour;
    if (diff.isNegative) {
      return (diff + 24);
    }
    return diff;
  }
}

extension TextStyleHelper on TextStyle {
  TextStyle get white => copyWith(color: AppTheme.whiteColor);
  TextStyle get black => copyWith(color: AppTheme.blackColor);
  TextStyle get greyDark => copyWith(color: AppTheme.greyColor.shade800);
  TextStyle get grey => copyWith(color: AppTheme.greyColor);
  TextStyle get primary => copyWith(color: AppTheme.primaryColor);
  TextStyle get red => copyWith(color: AppTheme.redColor);
  TextStyle get green => copyWith(color: AppTheme.greenColor);
  TextStyle get blue => copyWith(color: AppTheme.blueColor);

  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get normal => copyWith(fontWeight: FontWeight.normal);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
}

extension SizeHelper on BuildContext {
  double get statusBarHeight {
    return MediaQuery.of(this).viewPadding.top;
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }

  double get height {
    return MediaQuery.of(this).size.height - statusBarHeight;
  }

  double get keyboardSize {
    return MediaQuery.of(this).viewInsets.bottom;
  }

  bool get isKeyboardOpen {
    return MediaQuery.of(this).viewInsets.bottom > 0;
  }
}
