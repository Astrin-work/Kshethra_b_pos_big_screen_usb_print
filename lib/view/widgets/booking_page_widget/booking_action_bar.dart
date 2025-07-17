import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/asset/assets.gen.dart';
import '../../../utils/components/size_config.dart';
import '../../../view_model/booking_viewmodel.dart';

class BookingActionBar extends StatelessWidget {
  final int? amount;
  final double? height;
  final double? width;
  final String title;
  final int noOfScreens;
  final VoidCallback? onAddTap;
  final VoidCallback? onAmountTap;

  const BookingActionBar({
    super.key,
    this.height,
    this.width,
    this.amount,
    required this.title,
    required this.noOfScreens,
    this.onAddTap,
    this.onAmountTap,
  });

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) => Padding(
        padding: const EdgeInsets.only(left: 35.0, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            InkWell(
              onTap: () {
                if (onAmountTap != null) {
                  onAmountTap!();
                } else {
                  bookingViewmodel.bookingPreviewSecondFloatButton(
                    context,
                    amount,
                    noOfScreens,
                    title,
                  );
                }
              },
              child: Container(
                height: height ?? SizeConfig.screenWidth * 0.135,
                width: width ?? SizeConfig.screenWidth * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(Assets.images.homeBackground.path),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: amount != null
                      ? Text("₹ $amount", style: styles.whiteRegular20)
                      : Text(
                    "₹ ${bookingViewmodel.totalVazhipaduAmt}",
                    style: styles.whiteRegular20,
                  ),
                ),
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     if (onAddTap != null) {
            //       onAddTap!();
            //      bookingViewmodel.bookingAddNewDevottee,
            //     } else {
            //       Navigator.pop(context);
            //     }
            //   },
            //   child: Container(
            //     height: height ?? SizeConfig.screenWidth * 0.135,
            //     width: width ?? SizeConfig.screenWidth * 0.15,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(12),
            //       image: DecorationImage(
            //         image: AssetImage(Assets.images.homeBackground.path),
            //         fit: BoxFit.fill,
            //       ),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(3.0),
            //       child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(12),
            //           color: kWhite,
            //         ),
            //         child: const Icon(
            //           Icons.add,
            //           color: kDullPrimaryColor,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () {
                if (onAddTap != null) {
                  onAddTap!();

                  // Get BookingViewmodel from Provider
                  final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);

                  // Clear the form fields
                  bookingViewmodel.clearBookingForm();
                } else {
                  // If no custom action, pop and clear form
                  final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
                  bookingViewmodel.clearBookingForm();

                  Navigator.pop(context);
                }
              },
              child: Container(
                height: height ?? SizeConfig.screenWidth * 0.135,
                width: width ?? SizeConfig.screenWidth * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(Assets.images.homeBackground.path),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kWhite,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: kDullPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
