import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_styles.dart';
import '../../../view_model/booking_viewmodel.dart';

class RepCheckBoxWidget extends StatelessWidget {
  const RepCheckBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) => SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildOption("Once", bookingViewmodel, styles),
              _buildOption("Weekly", bookingViewmodel, styles),
              _buildOption("Daily", bookingViewmodel, styles),
              _buildOption("Monthly", bookingViewmodel, styles),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String label, BookingViewmodel viewmodel, AppStyles styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.tr(), style: styles.blackRegular15),
          Checkbox(
            value: viewmodel.toggleSelectedRepMethod(label),
            onChanged: (value) {
              viewmodel.switchSelectedRepMethod(label);
            },
            activeColor: kDullPrimaryColor,
          ),
        ],
      ),
    );
  }
}
