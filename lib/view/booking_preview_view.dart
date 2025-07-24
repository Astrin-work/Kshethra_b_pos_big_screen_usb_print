import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/responsive_layout.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/booking_action_bar.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/float_button_widget.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';

class BookingPreviewView extends StatelessWidget {
  final String page;
  const BookingPreviewView({
    super.key,
    required this.page,
    required String selectedRepMethod,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: ResponsiveLayout(
        pinelabDevice: FloatButtonWidget(title: 'Booking', noOfScreens: 4),
        mediumDevice: BookingActionBar(
          title: 'Booking',
          noOfScreens: 4,
          height: 65,
          type: 'booking',
        ),
        largeDevice: FloatButtonWidget(
          title: 'Booking',
          noOfScreens: 4,
          height: 75,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWidget(title: "Vazhipaddu".tr()),
            PreViewWidget(page: page),
          ],
        ),
      ),
    );
  }
}

class PreViewWidget extends StatelessWidget {
  final String page;
  const PreViewWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) {
          final bookings = bookingViewmodel.vazhipaduBookingList;
        final fromLang = "en";
        return SizedBox(
          height: SizeConfig.screenHeight * 0.8,
          width: SizeConfig.screenWidth / 1.1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kLightPrimaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BuildTextWidget(
                            text: booking.name.toString(),
                            // style: styles.blackSemi18,
                            textAlign: TextAlign.center,
                            // fromLang: fromLang,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            page == "booking"
                                ? (booking.star ?? "")
                                : (booking.option ?? ""),
                            style: styles.blackRegular13,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    BuildTextWidget(
                                      text: booking.vazhipadu?.tr() ?? "",
                                      size: 15,
                                      color: kBlack,
                                      fontWeight: FontWeight.w500,
                                      fromLang: fromLang,
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      "₹ ${booking.totalPrice ?? '0'}",
                                      style: styles.blackRegular15,
                                    ),
                                    // SizedBox(wid,),
                                    Spacer(),
                                    Row(
                                      children: [
                                        IconButton(
                                          color: kRed,
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            bookingViewmodel.vazhipaduDelete(
                                              index,
                                            );
                                          },
                                        ),
                                        // IconButton(
                                        //   icon: const Icon(Icons.add),
                                        //   onPressed: () {
                                        //     bookingViewmodel.popFunction(
                                        //       context,
                                        //     );
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                BuildTextWidget(
                                  text: booking.godname?.tr() ?? "",
                                  size: 14,
                                  color: kBlack,
                                  fromLang: fromLang,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Qty: ${booking.count ?? '0'}",
                                      style: styles.blackRegular13,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
