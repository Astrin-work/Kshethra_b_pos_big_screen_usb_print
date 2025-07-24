import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/asset/assets.gen.dart';
import '../../../utils/components/size_config.dart';
import '../../../view_model/booking_viewmodel.dart';

class FloatButtonWidget extends StatelessWidget {
  final int? amount;
  final double? height;
  final double? width;
  final String title;
  final int noOfScreens;
  final VoidCallback? payOnTap;
  final String? type;

  const FloatButtonWidget({
    super.key,
    this.height,
    this.width,
    this.amount,
    required this.title,
    required this.noOfScreens,
    this.payOnTap,
    this.type,
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
              onTap: () {},
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
                  child: Text(
                    "₹ ${amount ?? bookingViewmodel.totalVazhipaduAmt}",
                    style: styles.whiteRegular20,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (payOnTap != null) {
                  payOnTap!();
                } else {
                  bookingViewmodel.bookingPreviewSecondFloatButton(
                    context,
                    amount,
                    noOfScreens,
                    title,
                    type ?? 'booking', // fallback to default type
                  );
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
                    child: Icon(
                      Icons.arrow_forward,
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
