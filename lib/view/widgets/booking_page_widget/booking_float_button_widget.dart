import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';

class BookingFloatButtonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final void Function()? payOnTap;
  final void Function()? addOnTap;
  const BookingFloatButtonWidget({
    super.key,
    this.height,
    this.width,
    required this.payOnTap,
    this.addOnTap,
  });

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    return Consumer<BookingViewmodel>(
      builder:
          (context, bookingViewmodel, child) => Padding(
        padding: const EdgeInsets.only(left: 35.0, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: payOnTap,
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
                    "PAY ₹${bookingViewmodel.totalVazhipaduAmt}",
                    style: styles.whiteRegular20,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: addOnTap ?? bookingViewmodel.bookingAddNewDevottee,
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
                    child: Icon(Icons.person_add, color: kDullPrimaryColor),
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
