import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/model/user_booking_model.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/float_button_widget.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';
import '../utils/app_styles.dart';
import '../utils/components/responsive_layout.dart';
import '../utils/components/size_config.dart';


class AdvancedBookingPreviewView extends StatelessWidget {
  final String selectedRepMethod;
  final List<String> selectedDays;
  final int totalAmount;

  const AdvancedBookingPreviewView({
    super.key,
    required this.selectedRepMethod,
    required this.selectedDays,
    required this.totalAmount, required List<UserBookingModel> bookingList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<BookingViewmodel>(
        builder: (context, bookingViewmodel, child) {
          final total = bookingViewmodel.combinedTotalAmount + bookingViewmodel.postalAmount;

          return ResponsiveLayout(
            pinelabDevice: FloatButtonWidget(
              amount: total.toInt(),
              title: 'Advanced Booking',
              noOfScreens: 4,
              type: 'advance',
            ),
            mediumDevice: FloatButtonWidget(
              height: 65,
              amount: total.toInt(),
              title: 'Advanced Booking',
              noOfScreens: 4,
              type: 'advance',
            ),
            largeDevice: FloatButtonWidget(
              height: 75,
              amount: total.toInt(),
              title: 'Advanced Booking',
              noOfScreens: 4,
              type: 'advance',
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBarWidget(title: "Advanced Booking"),
          Expanded(
            child: AdvPreViewWidget(
              page: 'advanced booking',
              selectedRepMethod: selectedRepMethod,
              selectedDays: selectedDays,
              totalAmount: totalAmount,
            ),
          ),
        ],
      ),
    );
  }
}


class AdvPreViewWidget extends StatelessWidget {
  final String page;
  final String selectedRepMethod;
  final List<String> selectedDays;
  final int totalAmount;

  const AdvPreViewWidget({
    super.key,
    required this.page,
    required this.selectedRepMethod,
    required this.selectedDays,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    final fromLang = "en";

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) {
        final bookings = bookingViewmodel.vazhipaduBookingList;

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
                final repeatCount =
                booking.repMethode == 'Once' ? 1 : bookingViewmodel.repeatDays;
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
                                text: "${"Vazhipadu".tr()} : ${booking.vazhipadu ?? ''}",
                                style: styles.blackRegular13,
                                fromLang: fromLang,
                              ),

                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  bookingViewmodel.advBookingDelete(index);
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
                            text: "${"Name".tr()} : ${booking.name ?? ''}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),

                          const SizedBox(height: 10),

                          BuildTextWidget(
                            text: "${"Star".tr()} : ${booking.star ?? ''}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          const SizedBox(height: 10),
                          BuildTextWidget(
                            text: "${'vazhipadu_date'.tr()} : ${booking.date ?? DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          const SizedBox(height: 6),
                          BuildTextWidget(
                            text: "${'Devatha'.tr()} : ${booking.godname ?? ''}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          const SizedBox(height: 6),
                          BuildTextWidget(
                            text: booking.repMethode == "Once"
                                ? '${'Repeat'.tr()} : ${'Once'.tr()}'
                                : '${'Repeat'.tr()} : ${booking.repMethode} ${booking.day} (${bookingViewmodel.repeatDays} ${'TIMES'.tr()})',
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          const SizedBox(height: 6),
                          BuildTextWidget(
                            text: "${"Postal Charges".tr()} : ₹${bookingViewmodel.postalAmount}",
                            style: styles.blackRegular13,
                            fromLang: fromLang,
                          ),
                          const SizedBox(height: 12),
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



