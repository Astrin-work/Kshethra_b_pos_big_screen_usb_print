import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/responsive_layout.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/booking_float_button_widget.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/booking_form_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: Consumer<BookingViewmodel>(
        builder:
            (context, bookingViewmodel, child) => ResponsiveLayout(
              pinelabDevice: BookingFloatButtonWidget(
                payOnTap: () async {
                  bookingViewmodel.navigateBookingPreviewView(context);
                },
              ),

              mediumDevice: BookingFloatButtonWidget(
                height: 65,
                payOnTap: () {
                  bookingViewmodel.navigateBookingPreviewView(context);
                },
              ),
              largeDevice: BookingFloatButtonWidget(
                height: 75,
                payOnTap: () {
                  bookingViewmodel.navigateBookingPreviewView(context);
                },
              ),
            ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget(title: 'Vazhipaddu'.tr()),
            ResponsiveLayout(
              pinelabDevice: BookingFormWidget(),
              mediumDevice: BookingFormWidget(
                crossAxisSpace: SizeConfig.screenWidth * 0.15,
                mainAxisSpace: SizeConfig.screenWidth * 0.15,
              ),
              semiMediumDevice: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.01,
                ),
                child: BookingFormWidget(
                  crossAixisCount: 3,
                  crossAxisSpace: SizeConfig.screenWidth * 0.05,
                  mainAxisSpace: SizeConfig.screenWidth * 0.05,
                ),
              ),
              largeDevice: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.125,
                ),
                child: BookingFormWidget(
                  crossAixisCount: 4,
                  crossAxisSpace: SizeConfig.screenWidth * 0.015,
                  mainAxisSpace: SizeConfig.screenWidth * 0.015,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
