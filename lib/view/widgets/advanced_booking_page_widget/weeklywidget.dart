import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_styles.dart';
import '../../../view_model/booking_viewmodel.dart';

class WeeklyWidget extends StatelessWidget {
  const WeeklyWidget({super.key});

  final List<String> weekDays = const ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) => SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 18,
          runSpacing: 10,
          children: weekDays.map((day) {
            final isSelected = bookingViewmodel.toggleSelectedWeeklyDay(day);

            return ChoiceChip(
              label: Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              selectedColor: kDullPrimaryColor,
              backgroundColor: Colors.grey.shade200,
              onSelected: (_) => bookingViewmodel.switchSelectedWeeklyDay(day),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            );
          }).toList(),
        ),
      ),
    );
  }
}
