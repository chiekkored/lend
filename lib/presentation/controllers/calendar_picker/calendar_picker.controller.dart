import 'package:get/get.dart';
import 'package:lend/core/models/rates.model.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';

class CalendarPickerPageArgs {
  final bool isReadOnly;
  final List<DateTime> dates;
  final Rates rates;
  final void Function(List<DateTime> dates, int total) onSubmit;

  CalendarPickerPageArgs({
    required this.isReadOnly,
    required this.dates,
    required this.rates,
    required this.onSubmit,
  });
}

class CalendarPickerController extends GetxController {
  static CalendarPickerController get instance =>
      Get.find<CalendarPickerController>();

  final args = Get.arguments as CalendarPickerPageArgs;

  final RxList<DateTime> _selectedDates = <DateTime>[].obs;
  List<DateTime> get selectedDates => _selectedDates;

  final RxInt _totalPrice = 0.obs;
  int get totalPrice => _totalPrice.value;

  final RxInt _totalDays = 0.obs;
  int get totalDays => _totalDays.value;

  @override
  void onClose() {
    _selectedDates.close();
    _totalPrice.close();
    _totalDays.close();

    super.onClose();
  }

  void onTapSubmit() => args.onSubmit.call(selectedDates, totalPrice);

  void onCalendarChanged(List<DateTime> dates) async {
    if (args.isReadOnly) return;

    if (dates.first == dates.last) {
      _selectedDates.value = [dates.last];
      _totalPrice.value = 0;
      return;
    }

    if (args.dates.any(
      (av) => !av.isBefore(dates.last) && !av.isAfter(dates.first),
    )) {
      _selectedDates.value = [dates.last];
    } else {
      _selectedDates.value = dates;
    }
    calculateTotalPrice();
  }

  bool checkAvailability(DateTime date) {
    // Make last day available
    if ((args.dates.isNotEmpty) && date == args.dates.last) {
      return true;
    }

    return !(args.dates.any((av) => av == date));
  }

  void calculateTotalPrice() {
    try {
      if (selectedDates.length < 2 ||
          selectedDates.first == selectedDates.last) {
        _totalPrice.value = 0;
      }

      int totalPrice = 0;
      DateTime startDate = selectedDates.first;
      DateTime endDate = selectedDates.last;
      _totalDays.value = endDate.difference(startDate).inDays;

      if (args.rates.annually != null && totalDays >= 365) {
        totalPrice += args.rates.annually ?? 0;
        int remainingDays = totalDays - 365;
        if (remainingDays > 0) {
          // For simplicity, we'll apply daily rate for extra days beyond a year
          if (args.rates.daily != null) {
            totalPrice += remainingDays * (args.rates.daily ?? 0);
          }
        }
        _totalPrice.value = totalPrice;
      }

      DateTime currentDate = startDate;
      while (currentDate.isBefore(endDate)) {
        if (args.rates.monthly != null) {
          DateTime nextMonth = DateTime(
            currentDate.year,
            currentDate.month + 1,
            currentDate.day,
          );
          if (!nextMonth.isAfter(endDate)) {
            totalPrice += args.rates.monthly ?? 0;
            currentDate = nextMonth;
            continue;
          }
        }

        if (args.rates.weekly != null) {
          DateTime nextWeek = currentDate.add(const Duration(days: 7));
          if (!nextWeek.isAfter(endDate)) {
            totalPrice += args.rates.weekly ?? 0;
            currentDate = nextWeek;
            continue;
          }
        }

        if (args.rates.daily != null) {
          totalPrice += args.rates.daily ?? 0;
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }

      _totalPrice.value = totalPrice;
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }
}
