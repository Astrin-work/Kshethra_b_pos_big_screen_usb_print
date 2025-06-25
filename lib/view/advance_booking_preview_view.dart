import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/float_button_widget.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';
import '../utils/app_color.dart';
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
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      floatingActionButton: Consumer<BookingViewmodel>(
        builder: (context, bookingViewmodel, child) {
          final total = bookingViewmodel.combinedTotalAmount+bookingViewmodel.postalAmount;

          return ResponsiveLayout(
            pinelabDevice: FloatButtonWidget(
              amount: total.toInt(),
              title: 'Advanced Booking',
              noOfScreens: 4,
            ),
            mediumDevice: FloatButtonWidget(
              height: 65,
              amount: total.toInt(),
              title: 'Advanced Booking',
              noOfScreens: 4,
            ),
            largeDevice: FloatButtonWidget(
              height: 75,
              amount: total.toInt(),
              title: 'Advanced Booking',
              noOfScreens: 4,
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



                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kLightPrimaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 110),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      booking.name.toString(),
                                      style: styles.blackSemi18,
                                    ),
                                    Text(
                                      bookings[index].star.toString(),
                                      style: styles.blackRegular15,
                                    ),
                                    Text(
                                      bookings[index].date.toString(),
                                      style: styles.blackRegular13,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: kRed),
                                  onPressed: () {
                                    bookingViewmodel.advBookingDelete(index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    bookingViewmodel.popFunction(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First Line: Vazhipadu (count) - ₹price
                              Row(
                                children: [
                                  BuildTextWidget(
                                    text:
                                    "${booking.vazhipadu!.tr()}  (Qty -${bookings[index].count})",
                                    size: 14,
                                    color: kBlack,
                                  ),
                                  const Spacer(),
                                  Text(
                                    "₹ ${(int.tryParse(booking.price ?? '0') ?? 0) *
                                        (int.tryParse(booking.count ?? '1') ?? 1) *
                                        (booking.repMethode == 'Once' ? 1 : bookingViewmodel.repeatDays)}",
                                    style: styles.blackRegular15,
                                  ),

                                ],
                              ),
                              const SizedBox(height: 6),

                              BuildTextWidget(
                                text: booking.godname.toString(),
                                size: 14,
                                color: kBlack,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  BuildTextWidget(
                                    text: booking.repMethode == "Once"
                                        ? "Repeat: Once"
                                        : "Repeat: ${booking.repMethode} ${booking.day} ( ${bookingViewmodel.repeatDays} times)",
                                    size: 14,
                                    color: kBlack,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  BuildTextWidget(
                                    text:
                                    "Postal Charges: ₹${bookingViewmodel.postalAmount}",
                                    size: 14,
                                    color: kBlack,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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

