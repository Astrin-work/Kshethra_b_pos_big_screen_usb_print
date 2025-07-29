import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
          width: SizeConfig.screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final count = int.tryParse(booking.count ?? '1') ?? 1;
                final price = int.tryParse(booking.price ?? '0') ?? 0;
                final repeatCount = booking.repMethode == 'Once'
                    ? 1
                    : bookingViewmodel.repeatDays;
                final total = count * price * repeatCount;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kDefaultIconLightColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BuildTextWidget(
                                text:
                                "${"Vazhipadu".tr()} : ${booking.vazhipadu ?? ''}",
                                style: styles.blackRegular13,
                                fromLang: fromLang,
                              ),
                              IconButton(
                                icon:
                                const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  bookingViewmodel.vazhipaduDelete(
                                    index,
                                  );
                                },
                              ),
                            ],
                          ),
                          BuildTextWidget(
                            text: "Qty : ${booking.count ?? '0'}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          BuildTextWidget(
                            text:
                            "${"Name".tr()} : ${booking.name ?? ''}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          const SizedBox(height: 10),
                          BuildTextWidget(
                            text:
                            "${"Star".tr()} : ${booking.star ?? ''}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          const SizedBox(height: 10),
                          BuildTextWidget(
                            text:
                            "${'vazhipadu_date'.tr()} : ${booking.date ?? DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          const SizedBox(height: 6),
                          BuildTextWidget(
                            text:
                            "${'Devatha'.tr()} : ${booking.godname ?? ''}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          const SizedBox(height: 6),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              BuildTextWidget(
                                text: "${'Amount'.tr()} : ₹ $total",
                                style: styles.blackRegular13,
                                fromLang: fromLang,
                              ),
                            ],
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

