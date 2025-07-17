import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/responsive_layout.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/advance_booking_confirm_form.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/booking_float_button_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';

import '../model/api models/god_model.dart';
import '../utils/components/snack_bar_widget.dart';

class AdvancedBookingConfirmView extends StatelessWidget {
  final Vazhipadus selectedVazhipaadu;
  final int totalAmount;

  const AdvancedBookingConfirmView({
    super.key,
    required this.selectedVazhipaadu,
    required this.totalAmount,
  });

  void _handlePayTap(BuildContext context, BookingViewmodel viewmodel) {
    final isValid = viewmodel.advBookingKey.currentState?.validate() ?? false;

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please fill all required fields",
          color: Colors.grey,
        ).build(context),
      );
      return;
    }

    viewmodel.popFunction(context);
    viewmodel.setVazhipaduAdvBookingList(selectedVazhipaadu, context);
    // viewmodel.navigateAdvBookingPreview(context);
  }

  void _handleAddTap(BuildContext context, BookingViewmodel viewmodel) {
    final isValid = viewmodel.advBookingKey.currentState?.validate() ?? false;

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please fill all required fields",
          color: Colors.grey,
        ).build(context),
      );
      return;
    }

    viewmodel.bookingAddNewDevottee();
    viewmodel.popFunction(context);
    viewmodel.advBookingAddVazhipadu(selectedVazhipaadu, context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) => Scaffold(
        floatingActionButton: ResponsiveLayout(
          pinelabDevice: BookingFloatButtonWidget(
            payOnTap: () => _handlePayTap(context, bookingViewmodel),
            addOnTap: () => _handleAddTap(context, bookingViewmodel),
          ),
          mediumDevice: BookingFloatButtonWidget(
            height: 65,
            payOnTap: () => _handlePayTap(context, bookingViewmodel),
            addOnTap: () => _handleAddTap(context, bookingViewmodel),
          ),
          largeDevice: BookingFloatButtonWidget(
            height: 75,
            payOnTap: () => _handlePayTap(context, bookingViewmodel),
            addOnTap: () => _handleAddTap(context, bookingViewmodel),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWidget(title: selectedVazhipaadu.offerName),
              ResponsiveLayout(
                pinelabDevice: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: AdvancedBookingConfirmForm(
                    selectedVazhipaadu: selectedVazhipaadu,
                  ),
                ),
                mediumDevice: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.125,
                  ),
                  child: AdvancedBookingConfirmForm(
                    selectedVazhipaadu: selectedVazhipaadu,
                  ),
                ),
                largeDevice: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.125,
                  ),
                  child: AdvancedBookingConfirmForm(
                    selectedVazhipaadu: selectedVazhipaadu,
                  ),
                ),
              ),
              const SizedBox(height: 125),
            ],
          ),
        ),
      ),
    );
  }
}
