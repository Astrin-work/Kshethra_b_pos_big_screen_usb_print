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
          pinelabDevice:BookingFloatButtonWidget(
            payOnTap: () async {
              bookingViewmodel.navigateBookingPreviewView(context);
              print("-------btn pressed------");

              // await bookingViewmodel.submitVazhipadu(bookingViewmodel.selectedIndex);
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
        child: Column(
          children: [
            AppBarWidget(title: 'Vazhipaddu'.tr()),
            ResponsiveLayout(
              pinelabDevice: Padding(
                padding:  EdgeInsets.only(left: 15.0, right: 15),
                child: BookingFormWidget(),
              ),
              mediumDevice: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth * 0.100,
                  right: SizeConfig.screenWidth * 0.100,
                ),
                child: BookingFormWidget(
                  crossAxisSpace: SizeConfig.screenWidth * 0.15,
                  mainAxisSpace: SizeConfig.screenWidth * 0.15,
                ),
              ),
              semiMediumDevice: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth * 0.05,
                  right: SizeConfig.screenWidth * 0.05,

                ),
                child: BookingFormWidget(
                  crossAixisCount: 3,
                  crossAxisSpace: SizeConfig.screenWidth * 0.05,
                  mainAxisSpace: SizeConfig.screenWidth * 0.05,
                ),
              ),
              largeDevice: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth * 0.125,
                  right: SizeConfig.screenWidth * 0.125,
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