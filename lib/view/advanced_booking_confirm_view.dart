import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/responsive_layout.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/advance_booking_confirm_form.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/booking_float_button_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import '../model/api models/god_model.dart';

class AdvancedBookingConfirmView extends StatelessWidget {
  final Vazhipadus selectedVazhipaadu;
  final int totalAmount;

  const AdvancedBookingConfirmView({
    super.key,
    required this.selectedVazhipaadu,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) => Scaffold(
        floatingActionButton: ResponsiveLayout(
          pinelabDevice: BookingFloatButtonWidget(
            payOnTap: () {
              print("----------button1---------");
              bookingViewmodel.setVazhipaduAdvBookingList(
                selectedVazhipaadu,
                context,
              );
            },
            addOnTap: () {
              bookingViewmodel.setVazhipaduAdvBookingList(
                selectedVazhipaadu,
                context,
              );
            },
          ),
          mediumDevice: BookingFloatButtonWidget(
            height: 65,
            payOnTap: () {
              bookingViewmodel.popFunction(context);
              bookingViewmodel.setVazhipaduAdvBookingList(
                selectedVazhipaadu,
                context,
              );
              bookingViewmodel.navigateAdvBookingPreview(context);
            },
            addOnTap: () {
              bookingViewmodel.bookingAddNewDevottee();
              bookingViewmodel.popFunction(context);
              bookingViewmodel.advBookingAddVazhipadu(
                selectedVazhipaadu,
                context,
              );
            },
          ),
          largeDevice: BookingFloatButtonWidget(
            height: 75,
            payOnTap: () {
              bookingViewmodel.popFunction(context);
              bookingViewmodel.setVazhipaduAdvBookingList(
                selectedVazhipaadu,
                context,
              );
              bookingViewmodel.navigateAdvBookingPreview(context);
            },
            addOnTap: () {
              bookingViewmodel.bookingAddNewDevottee();
              bookingViewmodel.popFunction(context);
              bookingViewmodel.advBookingAddVazhipadu(
                selectedVazhipaadu,
                context,
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWidget(title: selectedVazhipaadu.offerName ?? 'Vazhipadu'),
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
